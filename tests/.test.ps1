
Set-Alias fsx "$env:FARHOME\FarNet\Modules\FSharpFar\fsx.exe"

# generate tasks for fsx files in /samples
Get-Item ../samples/*.fsx | .{process{
	Add-BuildTask -Name:$_.Name -Data:$_ -Jobs:{
		exec { fsx $Task.Data }
	}
}}
