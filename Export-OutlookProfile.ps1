# Note: References other variables and objects as well as other functions

Function Export-OutlookProfile {
	param (
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$User
	)
	$currentPath = Get-Location
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Current Path is $currentPath")
	
	Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("Exporting $($User.Name) Outlook Profile")
	
	# Building destination path
	$destination = "\\$global:DomainName\$($User.DomainName)\VDIMigration\Outlook\Profile"
	
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Loading $($User.localpath)\NTUSER.DAT ...")
	
	try {
		reg load HKLM\LoadTempUser "$($User.localpath)\NTUSER.DAT"
		# Start-Sleep -Seconds 5
	}
	catch {
		reg unload hklm\LoadTempUser
		reg load HKLM\LoadTempUser "$($User.localpath)\NTUSER.DAT"
	}
	
	if ($(Test-Path "HKLM:LoadTempUser") -eq $false) {
		Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("ERROR: Could not load the user's registry hive")
		reg unload hklm\LoadTempUser
		return $false
	}
	
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Searching for Outlook Profiles")
	
	# if ((Test-RegistryValue -Path "HKLM\LoadTempUserSOFTWARE\Microsoft\office\15.0\Outlook\Profiles") -eq $true)
	if ($(Test-Path -Path "HKLM:LoadTempUser\SOFTWARE\Microsoft\office\15.0\Outlook\Profiles") -eq $true) {
		Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("Outlook Profile Found")
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Exporting Outlook Profile Reg Key to $destination\OutlookProfile.reg")
		VerifyAndCreate-Path -path $destination
		reg export HKLM\LoadTempUser\SOFTWARE\Microsoft\office\15.0\Outlook\Profiles "$destination\OutlookProfile.reg" /y
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Unloading $($User.localpath)\NTUSER.DAT ...")
	}
	else {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("No Outlook Profile was found")
	}
	
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Unloading user's registry hive"
	cd $currentPath
	# PowerShell: Loading and Unloading Registry Hives
	# https://jrich523.wordpress.com/2012/03/06/powershell-loading-and-unloading-registry-hives/
	[gc]::collect()
	Start-Sleep -Seconds 10
	reg unload hklm\LoadTempUser
}