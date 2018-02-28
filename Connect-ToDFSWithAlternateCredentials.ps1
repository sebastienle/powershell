# Note: References global variables and other functions

Function Connect-ToDFSWithAlternateCredentials {
	Write-ToLogFile -Debug $true -Monitor $false -Local $true -Text "Establishing connection to DFS using alternate credentials"
	
	net use "\\$global:domainName\$global:DFSRootDir" /user:"$global:domainname\$global:SMBAccessUsername" "$global:SMBAccessPassword" | Out-Null
	# This is bad, might not even be required
	Start-Sleep -Seconds 10
	
	if (@(net use | Where-Object { $_.Contains("\\$global:domainName\$global:DFSRootDir") }).Count -eq 0) {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "ERROR: Connecting to DFS using alternate credentials failed"
		return $false
	}
	else {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Successfully established connection to DFS using alternate credentials"
		return $true
	}
}