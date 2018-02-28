# Simply verifies if we can reach one of a list of domain controllers

Function Verify-ConnectedToNetwork {
	if ($checkConnectedToNetwork -eq $true) {
		Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("Verifying that the computer is connected to the network")
		$connectionConfirmed = $false
		foreach ($domainController in $global:domainControllers) {
			if ($connectionConfirmed -eq $false) {
				if (Test-Connection -Cn $domainController -BufferSize 16 -Count 4 -ea 0 -quiet) {
					# Connectivity Confirmed
					Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("Connectivity to domain controller $domainController confirmed")
					$connectionConfirmed = $true
					return $true
				}
				else {
					# Test failed, keep trying with other DC
					Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Connectivity to domain controller $domainController failed, keep trying with other DC")
				}
			}
		}
		if ($connectionConfirmed -eq $false) {
			Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("Connectivity to all domain controllers failed")
		}
		return $false
	}
	else {
		Write-ToLogFile -Debug $true -Monitor $false -Local $true -Text ("Check disabled, not checking if computer is connected to the network")
	}
}