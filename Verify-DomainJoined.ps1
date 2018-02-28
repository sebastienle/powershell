# Domain name was stored in global variable

Function Verify-DomainJoined {
	# Check that the PC is joined to the aircanada.local domain
	if ($checkDomainMembership -eq $true) {
		Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("Verifying that the computer belongs to the aircanada.local domain")
		if (((gwmi win32_computersystem).partofdomain -eq $true) -AND ((gwmi win32_computersystem).domain -eq $global:domainName)) {
			write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("Computer is part of the Air Canada domain")
			return $true
		}
		else {
			Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("ERROR - Computer does not belong to the aircanada.local domain")
			return $false
		}
	}
	else {
		Write-ToLogFile -Debug $true -Monitor $false -Local $true -Text ("Check disabled, not checking if computer is a member of the domain")
	}
}