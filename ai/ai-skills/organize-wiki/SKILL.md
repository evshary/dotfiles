---
name: organize-wiki
description: Organize articles from a vault's Clippings folder into a wiki article index and monthly raw folders. Use when the user wants Markdown articles in `Clippings/` analyzed, classified into `wiki/文章分類.md` using a fixed retrieval-friendly format in Chinese, the index `updated` date refreshed, and all articles moved into `raw/YYYY.MM/` based on each file's `created` frontmatter date.
---

# Organize Wiki

Use this skill when the user wants to process article files from `Clippings/` into a reusable Obsidian index plus monthly archive folders.

## Expected vault structure

- Source folder: `Clippings/`
- Index file: `wiki/文章分類.md`
- Archive root: `raw/`

If the user gives different paths, follow the user.

## Target output format

Write or update `wiki/文章分類.md` with:

```md
---
updated: YYYY-MM-DD
---

# 分類名稱

- [[文章檔名]]
  主題：...
  摘要：...
  關鍵詞：...
  用途：...
  立場/結論：...
  個人筆記：
```

Rules:

- Use Obsidian wikilinks: `[[檔名]]`
- Keep the article title exactly aligned with the target note filename, without `.md`
- `updated` must be the current local date when the index is edited
- When updating `wiki/文章分類.md`, write category names and all field labels and field content in Chinese unless the article title itself should remain in the original language
- Fill every field for AI comprehension first: prefer explicit, self-contained wording that helps a future AI understand the article without reopening the source note
- `個人筆記` stays blank unless the user explicitly asks to fill it
- Keep summaries retrieval-friendly: self-contained, concrete, and rich in proper nouns, methods, and use cases
- Prefer concise categories, but create a new category when the existing ones are clearly wrong
- If no existing category is a good fit, add a new category instead of forcing the article into a vague or misleading one
- If an existing category becomes too broad, crowded, or semantically mixed, split it into more precise subcategories that improve later AI retrieval

## Workflow

1. Inspect `Clippings/` and list all Markdown articles.
2. Read each file's frontmatter and enough body content to infer:
   - the main topic
   - the core claim
   - the best category
   - useful keywords
   - the practical use case
3. Extract the `created` date from frontmatter.
4. Convert that `created` date to a monthly folder name in `YYYY.MM` format.
   - Example: `created: 2026-05-14` -> `raw/2026.05/`
5. Update `wiki/文章分類.md`.
   - If the file does not exist, create it.
   - If it exists, refresh the frontmatter `updated` field.
   - Add or refresh entries for the articles being processed.
   - Preserve unrelated manual notes when possible.
6. After the index is updated, create any missing `raw/YYYY.MM/` folders.
7. Move every processed article from `Clippings/` into its destination month folder under `raw/`.
8. Verify that:
   - `Clippings/` no longer contains the moved files
   - each article exists in the correct `raw/YYYY.MM/` folder
   - the wikilinks in `wiki/文章分類.md` match the final filenames

## Classification guidance

For each article, fill the fields with this intent:

- `主題`: short noun phrase for the content domain
- `摘要`: one to two sentences that let another AI understand the article without opening it
- `關鍵詞`: retrieval terms, names, methods, products, places, concepts
- `用途`: when this article should be cited or retrieved
- `立場/結論`: the author's main judgment, claim, or takeaway in one sentence

When writing these fields, optimize for future AI retrieval and understanding:

- avoid vague wording when a concrete name, method, person, place, or claim is available
- make each field understandable on its own, without relying on the article title alone
- prefer language that helps an AI decide whether the note is relevant to a later question

Good summaries mention concrete anchors such as:

- people: `Andrej Karpathy`, `Tiago Forte`
- systems or methods: `PARA`, `Zettelkasten`, `.claude`, `Groundbreakers`
- locations or entities: `Hormuz Strait`, `Byzantium`, `福衛八號`
- practical angle: why the article matters and when to retrieve it

## Editing guidance

- Default to updating the index in place instead of rewriting unrelated sections
- Keep category names readable for humans and stable for future retrieval
- If multiple articles fit one category, group them together
- If an article is ambiguous, choose the category that best matches how it would be searched later
- Do not preserve a weak category structure just for consistency; improve the taxonomy when a clearer grouping will help future retrieval
- When splitting a broad category, rename or regroup existing entries as needed so the index remains coherent

## Verification checklist

Before finishing, confirm:

- `wiki/文章分類.md` has a fresh `updated` date
- every processed article has all six fields
- every wikilink points to a real note filename
- every moved file went to `raw/YYYY.MM/` based on `created`
- `Clippings/` is empty for the processed files
