# Bulk replace "Appwrite" with "Indobase" in .markdoc files
# Protects URLs, emails, and technical references

$rootPath = "c:\Users\ASUS\Desktop\brey\appwrite"
$filesProcessed = 0
$replacementsMade = 0

Write-Host "Starting bulk replacement..." -ForegroundColor Green
Write-Host "Root path: $rootPath" -ForegroundColor Cyan

Get-ChildItem -Path $rootPath -Recurse -Filter "*.markdoc" | ForEach-Object {
    $filePath = $_.FullName
    $content = Get-Content $filePath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    
    if ($null -eq $content -or $content.Length -eq 0) {
        return
    }
    
    # Count matches before replacement
    $beforeMatches = ([regex]::Matches($content, '\bAppwrite\b')).Count
    
    if ($beforeMatches -gt 0) {
        $originalContent = $content
        
        # Replace "Appwrite" with "Indobase" but protect:
        # - URLs (http://, https://, www.)
        # - Email addresses (@appwrite.io)
        # - Package names (npm install appwrite, from 'appwrite')
        # - Docker commands (docker compose exec appwrite)
        # - File paths (appwrite.js, appwrite-file.png)
        
        # Use negative lookbehind and lookahead to protect URLs and emails
        # This regex matches "Appwrite" that is NOT:
        # - Preceded by http://, https://, @, /, ', ", `
        # - Followed by .io, .js, .png, etc.
        
        $pattern = '(?<!https://)(?<!http://)(?<!www\.)(?<!@)(?<!/)(?<![''"`])\bAppwrite\b(?!\.io)(?!\.js)(?!\.png)(?!-file)(?! vars)'
        
        $content = $content -creplace $pattern, 'Indobase'
        
        if ($content -ne $originalContent) {
            Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
            $afterMatches = ([regex]::Matches($content, '\bAppwrite\b')).Count
            $replaced = $beforeMatches - $afterMatches
            $replacementsMade += $replaced
            $filesProcessed++
            
            Write-Host "OK $($_.Name): $replaced replacements" -ForegroundColor Yellow
        }
    }
}

Write-Host "" -ForegroundColor Green
Write-Host "====== SUMMARY ======" -ForegroundColor Green
Write-Host "Files processed: $filesProcessed" -ForegroundColor Cyan
Write-Host "Total replacements: $replacementsMade" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Green
Write-Host "" -ForegroundColor Green
