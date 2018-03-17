<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.145
	 Created on:   	2018-03-16 9:42 PM
	 Created by:   	Sebastien
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

function Double() {
	param (
		[int]$Number
	)
	return $number * 2
}

function IsMain() {
	if ($($(Get-Variable -Name MyInvocation -Scope Script -ValueOnly | Select -Expand Line).Substring(0, 3).Trim()) -eq ". .") {
		return $false
	}
	else {
		return $true
	}
}

function Main() {
	[int]$numberToDouble = 100
	$result = Double -Number $numberToDouble
	Write-Output "Result is $result"
}

<#
Examine output from Invocation based on different scopes
'*** Global Invocation.MyCommand from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope Global -ValueOnly | Select -Expand MyCommand) | Out-Host;
'*** Local Invocation.MyCommand from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope Local -ValueOnly | Select -Expand MyCommand) | Out-Host;
'*** Private Invocation.MyCommand from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope Script -ValueOnly | Select -Expand MyCommand) | Out-Host;
'*** Script Invocation.MyCommand from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope Script -ValueOnly | Select -Expand MyCommand) | Out-Host;
'*** 0 (current) Invocation.MyCommand from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope 0 -ValueOnly | Select -Expand MyCommand) | Out-Host;
'*** 1 (parent) Invocation.MyCommand from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope 1 -ValueOnly | Select -Expand MyCommand) | Out-Host;
'*** Global Invocation.Line from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope Global -ValueOnly | Select -Expand Line) | Out-Host;
'*** Local Invocation.Line from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope Local -ValueOnly | Select -Expand Line) | Out-Host;
'*** Private Invocation.Line from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope Script -ValueOnly | Select -Expand Line) | Out-Host;
'*** Script Invocation.Line from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope Script -ValueOnly | Select -Expand Line) | Out-Host;
'*** 0 (current) Invocation.Line from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope 0 -ValueOnly | Select -Expand Line) | Out-Host;
'*** 1 (parent) Invocation.Line from Main: [{0}]' -f (Get-Variable -Name MyInvocation -Scope 1 -ValueOnly | Select -Expand Line) | Out-Host;
#>

if (IsMain -eq $true) {
	Main
}