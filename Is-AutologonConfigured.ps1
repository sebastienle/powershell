Function Is-AutologonConfigured {
	$autologonKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\WinLogon"
	$autologonName = "AutoAdminLogon"
	$autologonValue = "1"
	
	if ($(Get-ItemProperty -Path $autologonKey | Select-Object -ExpandProperty $autologonName -ErrorAction Stop) -eq $autologonValue) {
		return $true
	}
	else {
		return $false
	}
	
	return $false
}