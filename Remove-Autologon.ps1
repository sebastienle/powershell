Function Remove-Autologon {
	$autologonKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\WinLogon"
	$autologonName = "AutoAdminLogon"
	$autologonValue = "0"
	
	Set-ItemProperty -Path $autologonKey -Name $autologonName -Value $autologonValue
	
}