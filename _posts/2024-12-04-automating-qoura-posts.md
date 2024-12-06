---
title: Automating Quora Answers with Playwright and Marked.js
---

I once got a client on upwork who wanted me to automate qoura posts.
By combining **Playwright**, **Marked.js**, and a bit of JavaScript, I built a script that takes Markdown content and formats it perfectly for Quora. Let me walk you through how it works.

---

## The Problem

Quora doesn’t support Markdown directly, so you’re stuck manually applying formatting—bold text, headings, lists, blockquotes, etc.—which can be time-consuming. For someone who writes detailed answers or works with Markdown a lot, this can become frustrating. 

That’s where automation comes in. The goal was to take a Markdown file, parse it, and interact with Quora’s editor just like a human would—only faster and more consistently.

---

## The Solution

### Tools Used
- **[Playwright](https://playwright.dev/)**: A browser automation library to interact with Quora’s web interface.
- **[Marked.js](https://marked.js.org/)**: A Markdown parser that breaks down Markdown into tokens, making it easier to process.

Here’s a breakdown of the process:

1. **Login to Quora Automatically**: Using cookies for authentication.
2. **Parse the Markdown Content**: Convert Markdown into tokens that represent headings, paragraphs, lists, etc.
3. **Simulate User Actions**: Use Playwright to interact with Quora’s editor, applying the correct formatting for each token.

---

## How It Works

### Step 1: Parsing Markdown
The script uses Marked.js to tokenize the Markdown content into meaningful chunks. For example:
- `# Heading` becomes a "heading" token.
- `**Bold text**` becomes a "strong" token.
- Lists, blockquotes, and links are broken into their respective tokens.

```javascript
const marked = require("marked");
const tokens = marked.lexer(`
# My Answer
This is a **bold** text and a *italic* one.
- List item 1
- List item 2
[Link](https://example.com)
`);
```

### Step 2: Automating Formatting
For each token, we simulate actions like typing, clicking toolbar buttons, or navigating Quora’s editor. Here’s how it works for common elements:

#### Paragraphs
Text is typed directly into the editor, followed by pressing `Enter` to start a new paragraph.

```javascript
async function handleParagraph(page, token) {
  for (const inlineToken of token.tokens) {
    await handleInlineToken(page, inlineToken);
  }
  await page.keyboard.press("Enter");
}
```

#### Bold and Italic Text
The script selects text and applies formatting using Quora’s toolbar buttons.

```javascript
async function applyFormatting(page, text, buttonSelector) {
  await page.click(buttonSelector);
  await page.keyboard.type(text);
  await page.click(buttonSelector);
}
```

#### Lists
Ordered and unordered lists are handled by clicking the appropriate toolbar button and typing the list items.

```javascript
async function handleList(page, token) {
  const listType = token.ordered
    ? '[aria-label="Add ordered list"]'
    : '[aria-label="Add unordered list"]';
  await page.click(listType);
  for (const item of token.items) {
    await handleParagraph(page, item);
  }
}
```

#### Code Blocks
For code, the script clicks the "Format code" button and types the code block content.

```javascript
async function handleCode(page, token) {
  await page.click('[aria-label="Format code"]');
  await page.keyboard.type(token.text);
}
```

## Results

With this script, I can take any Markdown file, run the script, and have it neatly formatted and ready to post on Quora in seconds.
