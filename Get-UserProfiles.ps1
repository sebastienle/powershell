Function Get-UserProfiles {
	try {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Profile Retention: $global:nbDaysProfileRetention days")
		$tmpLocalProfiles = Get-WMIObject Win32_UserProfile -filter "Special != 'true'"
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Get users profiles names")
		return $tmpLocalProfiles
	}
	
	catch {
		
		return $null
	}
}