# Renames font files .ttf/.otf/.ttc/.fon to their real name (including style) using Windows extended properties

Write-Host "=== FONT RENAMING - VERSION WITH .FON AND STYLES ===" -ForegroundColor Cyan

# Initialize Shell to read extended properties (robust for all font types)
$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace((Get-Location).Path)

# Find the index of "Title" (may vary by Windows version or language)
$attrList = @{}
$details = @("Title")  # We only need Title, which includes family + style
for ($i = 0; $i -lt 400; $i++) {
    $detail = $objFolder.GetDetailsOf($null, $i)
    if ($details -contains $detail) {
        $attrList[$detail] = $i
    }
}

if (-not $attrList.ContainsKey("Title")) {
    Write-Host "The 'Title' attribute was not found in extended properties. Try on another Windows." -ForegroundColor Red
    pause; exit
}

Write-Host "'Title' attribute found at index $($attrList['Title'])" -ForegroundColor Yellow

# Case-insensitive filter to include .fon
$fonts = Get-ChildItem -Path "." -File | 
         Where-Object { $_.Extension -imatch '\.(ttf|otf|ttc|fon)$' }

Write-Host "Fonts found: $($fonts.Count)" -ForegroundColor Green
if ($fonts.Count -eq 0) { 
    Write-Host "No fonts detected" -ForegroundColor Red
    pause; exit 
}

$renombradas = 0
$fallidas = 0

foreach ($font in $fonts) {
    Write-Host "`nProcessing: $($font.Name)" -ForegroundColor White
    
    try {
        $fileObj = $objFolder.ParseName($font.Name)
        $title = $objFolder.GetDetailsOf($fileObj, $attrList["Title"]).Trim()
        
        if ([string]::IsNullOrWhiteSpace($title)) {
            throw "Empty or not found title"
        }
        
        Write-Host "  Detected title (family + style): $title" -ForegroundColor Magenta
        
        # Cleanup for valid file name
        $nuevoBase = $title -replace '[<>:"/\\|?*\x00-\x1F]', '_' -replace '\s+', ' ' -replace '\.{2,}', '.'
        $nuevoNombre = "$nuevoBase$($font.Extension)"
        
        # Avoid overwriting (for same families with different styles)
        $contador = 1
        $destino = Join-Path $font.DirectoryName $nuevoNombre
        while (Test-Path $destino -PathType Leaf) {
            $nuevoNombre = "$nuevoBase ($contador)$($font.Extension)"
            $destino = Join-Path $font.DirectoryName $nuevoNombre
            $contador++
        }
        
        Write-Host " → $nuevoNombre" -ForegroundColor Green
        Rename-Item -Path $font.FullName -NewName $nuevoNombre -ErrorAction Stop
        $renombradas++
    }
    catch {
        Write-Host "  Failed: $($_.Exception.Message)" -ForegroundColor Red
        $fallidas++
    }
}

Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Successfully renamed: $renombradas" -ForegroundColor Green
Write-Host "Failed or without title: $fallidas" -ForegroundColor Yellow
Write-Host "Total processed: $($fonts.Count)" -ForegroundColor White

Write-Host "`nProcess finished. Check the folder." -ForegroundColor Green
pause