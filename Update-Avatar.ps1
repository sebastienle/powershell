# Replaces the user logo in Win7

function Update-Avatar {
	$avatarFileName = "$scriptPath\user.bmp"
	$destinationDirectory = "$($env:ProgramData)\Microsoft\User Account Pictures"
	
	Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("Updating user avatar")
	
	try {
		if ($(Test-Path "$destinationDirectory\user.bmp") -eq $true) {
			Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("File user.bmp already exists, taking a backup of it")
			Copy-Item "$destinationDirectory\user.bmp" "$destinationDirectory\user.bmp.old.vdi.$(Get-Date -Format yyyy-MM-dd)"
		}
		Write-ToLogFile -Debug $true -Monitor $false -Local $true -Text ("Copying user avatar file $avatarFileName to $destinationDirectory")
		Copy-Item "$avatarFileName" "$destinationDirectory" -Force
	}
	catch {
		Write-ToLogFile -Debug $true -Monitor $false -Local $true -Text ("ERROR: Error copying user avatar file")
		return $false
	}
	
	return $true
}