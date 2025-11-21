# VS Code Snippets Sync Script (PowerShell)
# This script fetches VS Code snippets from a public GitHub repository

# Configuration
$RepoOwner = "martdegraaf"
$RepoName = "vscode-snippets"
$Branch = "main"
$SnippetsPath = "/"  # Path in the remote repo where snippets are stored
$LocalSnippetsDir = ".vscode"

Write-Host "Starting VS Code snippets sync..." -ForegroundColor Yellow

# Create local snippets directory if it doesn't exist
if (!(Test-Path $LocalSnippetsDir)) {
    New-Item -ItemType Directory -Path $LocalSnippetsDir | Out-Null
}

# GitHub API URL to list files
$ApiUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/contents/$SnippetsPath"
if ($Branch -ne "main" -and $Branch -ne "master") {
    $ApiUrl += "?ref=$Branch"
}

# GitHub raw content base URL
$BaseUrl = "https://raw.githubusercontent.com/$RepoOwner/$RepoName/$Branch/$SnippetsPath"

Write-Host "Fetching file list from repository..." -ForegroundColor Cyan

# Get list of files from GitHub repository
try {
    $Response = Invoke-RestMethod -Uri $ApiUrl -UseBasicParsing -ErrorAction Stop
    
    # Filter for snippet files (.json and .code-snippets)
    $SnippetFiles = $Response | Where-Object { $_.type -eq "file" -and ($_.name -like "*.json" -or $_.name -like "*.code-snippets") } | Select-Object -ExpandProperty name
    
    if ($SnippetFiles.Count -eq 0) {
        Write-Host "No snippet files found in the repository." -ForegroundColor Yellow
        exit 0
    }
    
    Write-Host "Found $($SnippetFiles.Count) snippet file(s) to sync." -ForegroundColor Cyan
    Write-Host ""
}
catch {
    Write-Host "Failed to fetch file list from repository." -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Function to download a snippet file
function Download-Snippet {
    param (
        [string]$File
    )
    
    $Url = "$BaseUrl/$File"
    $Dest = Join-Path $LocalSnippetsDir $File
    
    Write-Host "Fetching $File..." -NoNewline
    
    try {
        $Response = Invoke-WebRequest -Uri $Url -UseBasicParsing -ErrorAction Stop
        
        # Save the content to file
        [System.IO.File]::WriteAllText($Dest, $Response.Content)
        
        Write-Host " OK" -ForegroundColor Green
        return $true
    } catch {
        if ($_.Exception.Response.StatusCode -eq 404) {
            Write-Host " Not found (skipping)" -ForegroundColor Yellow
            # Remove the file if it exists
            if (Test-Path $Dest) {
                Remove-Item $Dest -Force
            }
        }
        else {
            Write-Host " Failed" -ForegroundColor Red
            Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
        }
        return $false
    }
}

# Sync all snippet files
$SuccessCount = 0
$FailCount = 0

foreach ($File in $SnippetFiles) {
    if (Download-Snippet -File $File) {
        $SuccessCount++
    }
    else {
        $FailCount++
    }
}

# Summary
Write-Host ""
Write-Host "---------------------------------------" -ForegroundColor Yellow
Write-Host "Sync complete!" -ForegroundColor Green
Write-Host "Successfully synced: $SuccessCount file(s)"
if ($FailCount -gt 0) {
    Write-Host "Failed/Skipped: $FailCount file(s)"
}
Write-Host "---------------------------------------" -ForegroundColor Yellow
