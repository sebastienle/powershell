# Contains horribles Write-Host statements - replace them

Function VerifyAndCreate-Path($path) {
	# Path variable HAS TO BE an absolute path and not contain a file name at the end, only folders
	# There are currently no checks for this, caller has to be responsible (yeah...)
	
	$localFunctionDebug = $false
	
	if ($global:Debug -eq $true) { Write-Host -ForegroundColor Green "$(Get-Date) VerifyAndCreate-Path function for path $path" }
	
	if ($localFunctionDebug -eq $true) { Write-Host -ForegroundColor Green "$(Get-Date) First two characters are: $($path.Substring(0, 2))" }
	
	# This fucntion has two different sections for UNC path (starting with \\) or local path
	if ($path.Substring(0, 2) -eq "\\") {
		$gradualPath = ""
		
		# Remove trailing backslash if there is one
		if ($path.Substring($path.Length - 1, 1) -eq '\') {
			$path = $path.Substring(0, $path.length - 1)
			if ($localFunctionDebug -eq $true) { Write-Host -ForegroundColor Green "$(Get-Date) Remove trailing backslash ( \ ) if there is one" }
		}
		
		$sectionNumber = 0
		foreach ($partOfPath in $path.Split('\')) {
			if ($sectionNumber -lt 4) {
				# This must be the first portion that contains the drive letter, like c:\
				# Therefore, we have nothing to do for now
				$gradualPath += '\' + $partOfPath
				if ($localFunctionDebug -eq $true) { Write-Host -ForegroundColor Green "$(Get-Date) Section Number: $sectionNumber" }
				if ($localFunctionDebug -eq $true) { Write-Host -ForegroundColor Green "$(Get-Date) Current gradual path: $gradualPath" }
				if ($sectionNumber -eq 1) { $gradualPath = $gradualPath.SubString(0, $gradualPath.Length - 1) }
				$sectionNumber += 1
			}
			else {
				$gradualPath += '\' + $partOfPath
				if ($localFunctionDebug -eq $true) { Write-Host -ForegroundColor Green "$(Get-Date) Section Number: $sectionNumber" }
				if ($localFunctionDebug -eq $true) { Write-Host -ForegroundColor Green "$(Get-Date) Current gradual path: $gradualPath" }
				if ($(Test-Path -Path $gradualPath) -eq $false) {
					New-Item -Path "$gradualPath" -Type Directory | Out-Null
					if ($localFunctionDebug -eq $true) { Write-Host -ForegroundColor Green "$(Get-Date) Creating folder $gradualPath" }
				}
				$sectionNumber += 1
			}
		}
		
	}
	else {
		$gradualPath = ""
		
		# Remove trailing backslash if there is one
		if ($path.Substring($path.Length - 1, 1) -eq '\') {
			$path = $path.Substring(0, $path.length - 1)
			if ($localFunctionDebug -eq $true) { write-host -ForegroundColor Green "$(Get-Date) Remove trailing backslash ( \ ) if there is one" }
		}
		
		foreach ($partOfPath in $path.Split('\')) {
			if ($partOfPath.Contains(":") -eq $true) {
				# This must be the first portion that contains the drive letter, like c:\
				# Therefore, we have nothing to do for now
				$gradualPath += $partOfPath
				if ($localFunctionDebug -eq $true) { Write-Host -ForegroundColor Green "$(Get-Date) This must be the first portion that contains the drive letter, like c:\" }
			}
			else {
				$gradualPath += '\' + $partOfPath
				if ($(Test-Path -Path $gradualPath) -eq $false) {
					New-Item -Path "$gradualPath" -Type Directory | Out-Null
					if ($localFunctionDebug -eq $true) { Write-Host -ForegroundColor Green "$(Get-Date) Creating folder $gradualPath" }
				}
			}
		}
	}
}