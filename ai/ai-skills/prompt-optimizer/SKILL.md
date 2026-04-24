---
name: prompt-optimizer
description: Optimizes user prompts for clarity and token efficiency. Use when a user request is ambiguous, verbose, or likely to result in inefficient tool usage.
---

# Prompt Optimizer

This skill helps you refine user prompts into clear, actionable, and token-efficient instructions.

## Workflow

1.  **Analyze the Prompt**: Evaluate the user's request for ambiguity, verbosity, and missing information.
2.  **Identify Inefficiencies**: Look for repetitive phrases, unnecessary context, or "chatty" language that adds token overhead without adding value.
3.  **Clarify Ambiguities**: If the intent is unclear, ask the user specific clarifying questions before proceeding.
4.  **Rewrite the Prompt**: Provide a optimized version of the prompt that is concise, direct, and preserves the original intent.

## Optimization Guidelines

### 1. Be Direct and Concise
- Remove conversational filler (e.g., "I was wondering if you could...", "Please help me with...").
- Use imperative verbs (e.g., "Create", "Update", "Analyze").
- Avoid redundant adjectives or adverbs.

### 2. Reduce Token Usage
- Use shorthand where appropriate (e.g., "feat" instead of "feature", "fix" instead of "bug fix").
- Eliminate repetitive context that is already available in the session.
- Favor structured lists or bullet points over long paragraphs.

### 3. Ensure Clarity
- Define specific output formats if needed (e.g., "JSON", "Markdown table").
- Specify constraints clearly (e.g., "under 50 words", "using only built-in libraries").
- If a task has multiple steps, list them sequentially.

## Examples

### Verbose/Ambiguous Prompt:
"Hey, I've been working on this Python script and it's acting a bit weird. It's supposed to read a CSV file and then do some calculations on the data, but it's giving me some errors. Can you take a look and maybe fix it for me? The file is data.csv."

### Optimized Prompt:
"Debug and fix the Python script to correctly read `data.csv` and perform its calculations. Report the specific error encountered and the fix applied."

### Ambiguous Prompt:
"Make the UI look better."

### Clarifying Questions:
- "Which specific component or page should be improved?"
- "Do you have a preferred style guide or design system (e.g., Material Design, Tailwind)?"
- "Are there specific UX issues, such as spacing or color contrast, that need to be addressed?"
