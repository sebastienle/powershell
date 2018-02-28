# Was used for a very specific use case so path are only indications
# Note: References other variables and objects as well as other functions

Function Inventory-LongFileNames {
	param (
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$User
	)
	
	Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("Starting inventory of files with long names")
	
	# This value is theoritically 260 but we are giving ourselves a tiny margin of error (1!)
	$maxAllowedPath = 259
	$pathDifference = 0
	$lfnFileName = "$env:COMPUTERNAME-LFNInventory.txt"
	
	# Calculating the difference in path
	# There are different scenarios for different users however. Check Robocopy-Documents for the basic logic. 	
	$currentPathLength = $User.localpath.length + "\Documents".Length
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Current Path Length: $currentPathLength")
	if ($User.IsShared -eq $true) {
		# In this scenario, the user will have a mapped drive to the Business Unit folder under VDIMigration
		# We add 3 to the length for "Y:\"
		$dfsPathLength = 3 + "$env:computername\$($User.DomainName)\Documents".Length
	}
	else {
		if ($User.IsFirstMigration -eq $true) {
			$dfsPathLength = "\\$global:DomainName\vdi\Data$($User.DataCenter)\$($User.DomainName)\Documents".Length
		}
		else {
			$dfsPathLength = "\\$global:DomainName\vdi\Data$($User.DataCenter)\$($User.DomainName)\Documents\$env:computername".Length
		}
	}
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("DFS Path Length: $dfsPathLength")
	
	if ($dfsPathLength -ge $currentPathLength) {
		$pathDifference = $dfsPathLength - $currentPathLength
		$maxAllowedPath = $maxAllowedPath - $pathDifference
	}
	else {
		# The DFS path is shorter than the current path, nothing to do
		return
	}
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Difference in Path Length: $pathDifference")
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Max Allowed Local Path Length: $maxAllowedPath")
	
	# Generate the list of files with path longer than $maxAllowedPath
	if ($User.IsShared -eq $true) {
		$outputFile = "\\$global:DomainName\vdi\Data$($User.DataCenter)\VDIMigration\$(Get-Profile)\$env:computername\$($User.DomainName)\VDIMigration\LFN\"
	}
	else {
		if ($User.IsFirstMigration -eq $true) {
			$outputFile = "\\$global:DomainName\vdi\Data$($User.DataCenter)\$($User.DomainName)\VDIMigration\LFN\"
		}
		else {
			$outputFile = "\\$global:DomainName\vdi\Data$($User.DataCenter)\$($User.DomainName)\VDIMigration\LFN\"
		}
		
	}
	VerifyAndCreate-Path -path $outputFile
	$outputFile = "$outputFile\$lfnFileName"
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Running Command: cmd /c dir ""$($User.Localpath)\Documents"" /s /b | ? { $_.length -gt $maxAllowedPath } | Out-File $outputFile")
	cmd /c dir "$($User.Localpath)\Documents" /s /b | ? { $_.length -gt $maxAllowedPath } | Out-File $outputFile
	
}