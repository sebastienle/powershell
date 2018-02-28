# La fonction Add-Admin ajoute l'usager spécifier en paramêtre dans le groupe Administrateur local
# ex.: "Add_Admin JohnDoe" ajoute JohnDoe au groupe administrateur local
Function Set-Admin {
	Param ([String]$user)
	
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Adding user to the local administrators group of the workstation")
	
	#
	# Test afin de déterminer le nom exact du groupe administrateur (Administrators ou Administrateurs)
	#
	$Lg = "FR"
	
	# This line stopped working when we switched execution to localsystem - had to replace it with WMI query
	# $Groups = Net localgroup
	$Groups = Get-WMIObject Win32_Group -filter "DOMAIN= ""$($env:computername)"""
	ForEach ($NomGrp in $Groups) {
		if ($NomGrp.Name -eq "Administrators") {
			$Lg = "EN"
		}
	}
	
	# Verification si l'usager est deja membre du groupe local d'administrateurs
	Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("Checking if user is already a member of the local administrators group")
	if ($Lg -eq "FR") {
		$checkUser = net localgroup administrateurs | Select-String "$global:domainNameShort\\$user" -Quiet
	}
	else {
		$checkUser = net localgroup administrators | Select-String "$global:domainNameShort\\$user" -Quiet
	}
	if ($checkUser -eq $true) {
		Write-ToLogFile -Debug $true -Monitor $false -Local $false -Text ("User $global:domainName\$user is already a member of the local administrators group")
		return $true
	}
	
	#
	# Ajout de l'usagers spécifier en paramêtre dans le groupe local administrateur
	#
	if ($Lg -eq "EN") {
		Write-ToLogFile -Debug $true -Monitor $false -Local $true -Text ("Adding $global:domainName\$user to Administrators group")
		net localgroup Administrators  /ADD $global:domainName\$user
	}
	else {
		Write-ToLogFile -Debug $true -Monitor $false -Local $true -Text ("Adding $global:domainName\$user to Administrateurs group")
		net localgroup Administrateurs /ADD $global:domainName\$user
	}
	
}