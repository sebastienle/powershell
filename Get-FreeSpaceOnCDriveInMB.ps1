# Note: References other variables and objects as well as other functions

Function Get-FreeSpaceOnCDriveInMB {
	$cDrive = Get-WmiObject Win32_LogicalDisk -ComputerName localhost -Filter "DeviceID='C:'"
	$cDriveFreeSpace = $cDrive.FreeSpace / 1024 / 1024
	return $cDriveFreeSpace
}