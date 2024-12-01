# Generates test tasks for fsx files in /samples.

Set-Alias fsx "$env:FARHOME\FarNet\Modules\FSharpFar\fsx.exe"
$IsFar = $Host.Name -eq 'FarHost'

Get-ChildItem ../samples -Recurse -Include *.fsx | .{process{
	if ($IsFar) {
		task $_ {
			$Far.InvokeCommand("fs: exec: file=$($Task.Name)")
		}
	}
	else {
		task $_ {
			exec { fsx $Task.Name }
		}
	}
}}

<#
It is much faster to run all scripts by fsx as:

	fsx --exec --load:a.fsx --load:b.fsx ...

But we want a new session for each script and better test log.
#>
