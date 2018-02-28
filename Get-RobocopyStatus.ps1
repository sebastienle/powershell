Function Get-RobocopyStatus {
	param (
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$ReturnCode
	)
	
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Robocopy exit code to be interpreted: $ReturnCode"
	
	# Depending on how the return code evolves, it might be worth it to change this to a switch statement with
	# all 16 robocopy return codes
	If (($ReturnCode -ge 0) -and ($ReturnCode -le 3)) {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Robocopy status is SUCCESS"
		return "SUCCESS"
	}
	
	elseif (($ReturnCode -ge 4) -and ($ReturnCode -le 15)) {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Robocopy status is WARNING"
		return "WARNING"
	}
	
	elseif ($ReturnCode -eq 16) {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Robocopy status is ERROR"
		return "ERROR"
	}
	
	else {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Robocopy status is UNKNOWN"
		return "UNKNOWN"
	}
	
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Robocopy status was outside the range of expected values"
	return "UNKNOWN"
}