# Note: References other variables and objects as well as other functions

Function StartandMonitor-Robocopy {
	param (
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$robocopyCommand,
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$monitorForTime
	)
	
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Robocopy Command: $robocopyCommand")
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Monitor Robocopy Command for time: $monitorForTime")
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Maximum End Time: $global:dataMigrationMaxEndTime")
	
	if ($global:dataMigrationKillSwitch -eq $true) {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Data Migration Kill Switch triggered. Will not attempt copy.")
		return 99
	}
	
	$robocopyScriptBlock = {
		param (
			[parameter(Mandatory = $true)]
			[ValidateNotNullOrEmpty()]
			$robocopyCmd
		)
		# Write-Host $robocopyCmd
		Invoke-Expression $robocopyCmd
		$LASTEXITCODE
	}
	
	if ($monitorForTime -eq $false) {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Launching Robocopy command"
		$currentJob = Start-Job -ScriptBlock $robocopyScriptBlock -ArgumentList $robocopyCommand -Name "VDI Data Migration"
		# Evaluating return code
		$robocopyExitCode = $currentJob | Wait-Job | Receive-Job -ErrorAction SilentlyContinue
	}
	else {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Launching Robocopy command"
		$currentJob = Start-Job -ScriptBlock $robocopyScriptBlock -ArgumentList $robocopyCommand -Name "VDI Data Migration"
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Monitoring Robocopy command Status"
		do {
			Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Current Time Check... Current Time: $(Get-Date)   Maximum Allowed End Time: $global:dataMigrationMaxEndTime"
			if ($(Get-Date) -ge $global:dataMigrationMaxEndTime) {
				$global:dataMigrationKillSwitch = $true
				Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Data Migration $dataMigrationMaxRunTime Minutes Window Exceeded... Stopping Robocopy"
			}
			
			Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Migration Status: $($currentJob.State)"
			if ($dataMigrationKillSwitch -eq $true) {
				Stop-Job -Id $currentJob.id
				Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Forcefully stopped Job $($currentJob.ID)"
				Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text "ERROR: Data Migration Exceeded its $dataMigrationMaxRunTime Minutes Window"
				Move-MonitoringFlagFile -OldStatus $global:StatusRunning -NewStatus $global:StatusWarning
				# Changed this return code to prevent ZenWorks re-run
				exit
			}
			Start-Sleep -Seconds 10
		}
		until ($currentJob.State -ne "Running")
		
		# Grabbing Job Output
		$robocopyExitCode = $currentJob | Receive-Job -ErrorAction SilentlyContinue
	}
	
	# Evaluating robocopy exit code found on the last line
	$robocopyExitCode = $robocopyExitCode[($robocopyExitCode.Length - 1) .. ($robocopyExitCode.Length)]
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text "Robocopy Exit Code from Job: $robocopyExitCode"
	
	Write-ToLogFile -Debug $true -Monitor $false -Local $true -Text "Robocopy Command Completed"
	return $robocopyExitCode
}