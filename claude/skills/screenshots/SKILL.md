---
name: screenshots
description: List images in the Windows Screenshots folder (/mnt/c/Users/piete/Pictures/Screenshots) and let the user pick one or more to load into context. Use when the user says "screenshot", "my screenshots", "pick a screenshot", "/screenshots", or wants to attach/view a recent screen capture.
---

# Screenshots

Lists images in `/mnt/c/Users/piete/Pictures/Screenshots`, lets the user pick via the
`AskUserQuestion` UI (no token-heavy text menu), then reads the selected image(s) into context.

## Arguments

The skill may receive an argument (e.g. `/screenshots latest`). When present, skip the
`AskUserQuestion` UI and resolve directly against the newest-first list from step 1:

- `latest` / `newest` / `last` → read the single newest image.
- `latest N` / `last N` (e.g. `latest 3`) → read the N newest.
- A number `3` → the 3rd newest; a range `2-5` → those; `all` → every image.
- A filename / substring → match against the listed paths.

No argument → run the interactive flow below.

## Steps

1. **List images, newest first.** Use `find` (NOT a brace glob — zsh aborts the whole
   command when one extension has no match):

   Filter extensions with `grep` (NOT `find -iname '*.png'` — the unquoted glob chars
   trip the permission check and force a prompt):

   ```bash
   find /mnt/c/Users/piete/Pictures/Screenshots -maxdepth 1 -type f \
     -printf '%T@ %TY-%Tm-%Td %TH:%TM %p\n' 2>/dev/null \
     | sort -rn | cut -d' ' -f2- \
     | grep -iE '\.(png|jpe?g|gif|webp|bmp)$' | head -40
   ```

2. **Present via `AskUserQuestion` — do NOT echo a numbered menu** (that burns output
   tokens). Build one question, `multiSelect: true`, with the newest files as options:
   - `label`: filename (trim the `Screenshot ` prefix if it helps fit), `description`: modified time.
   - `AskUserQuestion` caps at 4 options. List the 4 newest. The user can pick the built-in
     "Other" to type a filename, index, range, or `all` for older shots.

3. **Resolve the answer to full paths.** Map selected labels back to the paths from step 1.
   If the user typed something via "Other" (index `3`, range `2-5`, `all`, `latest`), resolve
   against the listed order.

   If the user already named which screenshot(s) they want in their request, skip the UI and
   match directly.

4. **Read each selected image** with the Read tool (it renders images visually). Pass the
   full quoted path.

## Notes

- Empty folder → tell the user no images found, don't error out.
- Filenames have spaces (Windows screenshots do) — quote paths for Read/Bash.
- Newest-first; the user usually wants the most recent.
