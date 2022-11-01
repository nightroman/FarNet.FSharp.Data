# Generates test tasks for fsx files in /samples.

Set-Alias fsx "$env:FARHOME\FarNet\Modules\FSharpFar\fsx.exe"

Get-Item ../samples/*.fsx | .{process{
	Add-BuildTask -Name:$_.Name -Data:$_ -Jobs:{
		if ($Host.Name -eq 'FarHost') {
			$Far.InvokeCommand("fs: exec: file=$($Task.Data)")
		}
		else {
			exec { fsx $Task.Data }
		}
	}
}}
