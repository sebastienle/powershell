# Note: References other variables and objects as well as other functions

Function Is-UserAccountInAD {
	param (
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$Username
	)
	
	$isUserAccountInAD = $false
	$onlyAccountName = $Username.Split('\')[1]
	
	$strFilter = "(&(objectCategory=User)(sAMAccountName=$onlyAccountName))"
	
	$objDomain = New-Object System.DirectoryServices.DirectoryEntry
	
	$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
	$objSearcher.SearchRoot = $objDomain
	$objSearcher.PageSize = 1000
	$objSearcher.Filter = $strFilter
	$objSearcher.SearchScope = "Subtree"
	
	# $colProplist = @("name","samAccountName")
	# foreach ($i in $colPropList) { $objSearcher.PropertiesToLoad.Add($i) }
	
	$colResults = $objSearcher.FindAll()
	
	if ($colResults.Count -eq 1) {
		$isUserAccountInAD = $true
	}
	
	# foreach ($objResult in $colResults)
	# {
	# 	# $objItem = $objResult.Properties; $objItem.name
	# 	if ($objResult.properties['samAccountName'] -eq $onlyAccountName)
	# 	{
	# 		$isUserAccountInAD = $true	
	# 	}
	# } 
	
	return $isUserAccountInAD
}