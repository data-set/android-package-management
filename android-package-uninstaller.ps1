$packages = Get-Content "packages.txt"

# Create output folder if not exists
$outputDir = "output"
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Generate timestamp
$timestamp = Get-Date -Format "dd-MM-yyyy__HH-mm-ss"

$successFile = "$outputDir\uninstalled_$timestamp.txt"
$failedFile = "$outputDir\failed_$timestamp.txt"

$success = @()
$failed = @()

foreach ($pkg in $packages) {
	Write-Host "`n`nProcessing $pkg"
	
	$result = .\adb.exe shell pm uninstall --user 0 $pkg

	if ($result -match "Success") {
		$success = $success + $pkg
        Write-Host "`nUninstalled"
	} else {
		$failed = $failed + $pkg
        Write-Host "`nFailed to remove package"
	}
}

# Write results
$success | Out-File $successFile
$failed | Out-File $failedFile

Write-Host "`n Done!"
Write-Host "Removed: $($success.Count)"
Write-Host "Failed: $($failed.Count)"
Write-Host "Logs saved to: $outputDir"

.\adb.exe kill-server