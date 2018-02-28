# Desktop Lock was installed disabled by default, migration enabled it. 
Function Enable-DesktopLock {
	$desktopLockRegistryKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
	$desktopLockRegistryName = "Shell"
	$desktopLockRegistryValue = "C:\Program Files\Citrix\ICA Client\SelfServicePlugin\selfservice.exe"
	$desktopLockRegistryValueType = "STRING"
	
	Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("Enabling Desktop Lock")
	
	if ($(Test-RegistryValue -Path $desktopLockRegistryKey -Value $desktopLockRegistryName) -eq $true) {
		Set-ItemProperty -Path $desktopLockRegistryKey -Name $desktopLockRegistryName -Value $desktopLockRegistryValue
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Setting $desktopLockRegistryKey $desktopLockRegistryName")
	}
	else {
		New-Item -Path $desktopLockRegistryKey -Force | Out-Null
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Creating $desktopLockRegistryKey")
		New-ItemProperty -Path $desktopLockRegistryKey -Name $desktopLockRegistryName -Value $desktopLockRegistryValue -PropertyType $desktopLockRegistryValueType | Out-Null
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Setting $desktopLockRegistryKey $desktopLockRegistryName")
	}
	
}