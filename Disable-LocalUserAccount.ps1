# Note: References other variables and objects as well as other functions

Function Disable-LocalUserAccount {
	param (
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$User
	)
	
	Write-ToLogFile -Debug $true -Monitor $false -Local $true -Text ("Disabling $($User.LocalName) user account")
	
	foreach ($comp in $env:computername) {
		foreach ($Usr in $User) {
			$user_acc = Get-LocalUserAccount -ComputerName $comp -UserName $Usr.LocalName
			$user_acc.userflags.value = $user_acc.userflags.value -bor "0x0002"
			$user_acc.SetInfo()
		}
	}
	
	Write-ToLogFile -Debug $true -Monitor $true -Local $true -Text ("User $($User.LocalName) is disabled")
	#Create-MonitoringFlagFile -Function ("Disable-LocalUserAccount")
	
}