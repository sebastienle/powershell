# Dumb write log functions that can write in 3 different places
# Note: References other variables and objects as well as other functions

function Write-ToLogFile() {
	param (
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$Text,
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$Debug,
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$Monitor,
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$Local
	)
	
	#If DEBUG is True , Write log to local
	if ($Debug -eq $true) {
		if (Test-Path $debugLogFileDir) {
			# Perfect the path exists
		}
		else {
			VerifyAndCreate-Path($debugLogFileDir)
		}
		Add-content "$DebugLogFileDir\$DebugLogFileName" -value "$(Get-Date) $text"
		write-host -ForegroundColor Green "$(Get-Date) $text"
	}
	
	#If MONITOR is true , write to network	
	if ($Monitor -eq $true) {
		if (Test-Path $networkLogFileDir) {
			# Perfect the path exists
		}
		else {
			VerifyAndCreate-Path($networkLogFileDir)
		}
		Add-Content -Path "$NetworkLogFileDir\$NetworkLogFileName" -value "$(Get-Date) $text"
		# write-host -ForegroundColor Green "$(Get-Date) $text"
	}
	
	#If LOCAL is true , write to host
	if ($Local -eq $true) {
		if (Test-Path $localLogFileDir) {
			# Perfect the path exists
		}
		else {
			VerifyAndCreate-Path($localLogFileDir)
		}
		Add-content "$localLogFileDir\$localLogFileName" -value "$(Get-Date) $text"
		# write-host -ForegroundColor Green "$(Get-Date) $text"
	}
}