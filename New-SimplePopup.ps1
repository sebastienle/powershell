# Simplest of popup
function New-SimplePopup {
	$popupcmd = "msg.exe * ""The scheduled migration is in progress `nPlease do not manually shutdown or reboot your PC `nYour computer will restart automatically once the process is completed `nThank you for your collaboration"""
	Invoke-Expression $popupcmd
}