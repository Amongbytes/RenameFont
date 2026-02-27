# Font Renamer Script

A simple PowerShell script to rename font files (.ttf, .otf, .ttc, .fon) based on their internal "Title" metadata (which often includes family name and style, like "Arial Bold"). This helps fix folders with misnamed fonts.

## Features
- Supports common font formats: .ttf, .otf, .ttc, and .fon (bitmap fonts).
- Extracts the real name (family + style) using Windows extended file properties.
- Handles duplicates by adding counters (e.g., "Montserrat Bold (1).ttf").
- Case-insensitive file detection for compatibility with Windows PowerShell 5.1+.
- Verbose output to track progress, successes, and failures.
- No external dependencies required (uses built-in COM objects).

## Requirements
- Windows 10 or later (tested on Windows 10).
- PowerShell 5.1 (default on Windows) or higher.
- Execution policy allowing scripts: Run `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned` as Administrator if needed.

## How to Use
1. **Download the Script**:
   - Clone this repository or download `Renombrar-Fuentes-FINAL-v2.ps1` (English version: `Font-Renamer.ps1`).

2. **Prepare Your Fonts**:
   - Place the script file in the same folder as your font files.
   - Ensure the folder contains only the fonts you want to rename (back up originals first!).

3. **Run the Script**:
   - Right-click the .ps1 file and select "Run with PowerShell".
   - The script will:
     - Scan for .ttf, .otf, .ttc, .fon files.
     - Extract the internal "Title" (e.g., "Montserrat Regular").
     - Rename each file accordingly.
     - Display progress in the console.

4. **Example Output**: