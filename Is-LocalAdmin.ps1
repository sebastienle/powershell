# Only verifies if user is a direct member of the local admins group - Supports English and French

Function Is-LocalAdmin {
	Param ([string]$AccountName)
	
	#
	# Test afin de déterminer le nom exact du groupe administrateur (Administrators ou Administrateurs)
	#
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Verifying if user is a local administrator of the workstation")
	$Lg = "FR"
	
	# This line stopped working when we switched execution to localsystem - had to replace it with WMI query
	# $Groups = Net Localgroup
	$Groups = Get-WMIObject Win32_Group -filter "DOMAIN= ""$($env:computername)"""
	ForEach ($NomGrp in $Groups) {
		# Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Local Group: $($NomGrp.Name)")
		IF ($NomGrp.Name -eq "Administrators") {
			$Lg = "EN"
		}
	}
	
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Workstation language appears to be $Lg")
	# Selon la langue : collecter les membres du groupe administrateurs et les placer dans la variable $Members 
	
	IF ($Lg -eq "EN") {
		$Members = net localgroup administrators | where { $_ -AND $_ -notmatch "command completed successfully" } | select -skip 4
	}
	ELSE {
		$Members = net localgroup administrateurs | where { $_ -AND $_ -notmatch "commande s'est" } | select -skip 4
	}
	
	# Rechercher dans la liste des membres ($Memebers) si l'usager spécifier en paramêtre est présent
	
	$Res = $false
	ForEach ($UnNom in $Members) {
		If ($UnNom -eq $AccountName) {
			$Res = $true
		}
	}
	
	# Si présent retourner true sinon retourner false
	
	Return $Res
}