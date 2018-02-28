Function Disconnect-FromDFSWithAlternateCredentials {
	net use "\\$global:domainName\$global:DFSRootDir" /delete | Out-Null
}