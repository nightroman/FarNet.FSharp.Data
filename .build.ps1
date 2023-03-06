<#
.Synopsis
	Build script, https://github.com/nightroman/Invoke-Build
#>

param(
	$Configuration = (property Configuration Release),
	$FarHome = (property FarHome C:\Bin\Far\x64)
)

Set-StrictMode -Version 3
$ModuleName = 'FarNet.FSharp.Data'
$ModuleRoot = "$FarHome\FarNet\Lib\$ModuleName"
$Description = 'FSharp.Data package for FarNet.FSharpFar'

# Synopsis: Remove temp files.
task clean {
	remove src\bin, src\obj, README.htm, *.nupkg, z
}

# Synopsis: Build and publish (post build event).
task build {
	Set-Location src
	exec { dotnet build -c $Configuration }
}

# Synopsis: Post build event.
task publish {
	Set-Location src
	$null = mkdir $ModuleRoot -Force

	$xml = [xml](Get-Content "$ModuleName.fsproj")
	$node1 = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data"]')
	$from1 = "$HOME\.nuget\packages\FSharp.Data\$($node1.Version)"
	$node2 = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data.LiteralProviders"]')
	$from2 = "$HOME\.nuget\packages\FSharp.Data.LiteralProviders\$($node2.Version)"

	Copy-Item -Destination $ModuleRoot $(
		"$ModuleName.ini"
		"bin\$Configuration\net7.0\FarNet.FSharp.Data.dll"
		"bin\$Configuration\net7.0\FarNet.FSharp.Data.xml"
		#
		"$from1\lib\netstandard2.0\FSharp.Data.dll"
		"$from1\lib\netstandard2.0\FSharp.Data.xml"
		"$from1\typeproviders\fsharp41\netstandard2.0\FSharp.Data.DesignTime.dll"
		#
		"$from2\lib\netstandard2.0\FSharp.Data.LiteralProviders.Runtime.dll"
		"$from2\typeproviders\fsharp41\netstandard2.0\DotEnvFile.dll"
		"$from2\typeproviders\fsharp41\netstandard2.0\FSharp.Data.LiteralProviders.DesignTime.dll"
	)
}

# Synopsis: Set $script:Version.
task version {
	($script:Version = switch -Regex -File Release-Notes.md {'##\s+v(\d+\.\d+\.\d+)' {$Matches[1]; break} })
	assert $script:Version
}

# Synopsis: Convert markdown to HTML.
task markdown {
	assert (Test-Path $env:MarkdownCss)
	exec { pandoc.exe @(
		'README.md'
		'--output=README.htm'
		'--from=gfm'
		'--embed-resources'
		'--standalone'
		"--css=$env:MarkdownCss"
		"--metadata=pagetitle=$ModuleName"
	)}
}

# Synopsis: Collect package files.
task package markdown, {
	remove z
	$toModule = mkdir "z\tools\FarHome\FarNet\Lib\$ModuleName"

	Copy-Item -Destination z @(
		'README.md'
	)

	Copy-Item -Destination $toModule @(
		'README.htm'
		'LICENSE'
		"$ModuleRoot\FarNet.FSharp.Data.ini"
		"$ModuleRoot\FSharp.Data.dll"
		"$ModuleRoot\FSharp.Data.xml"
		"$ModuleRoot\FSharp.Data.DesignTime.dll"
	)
}

# Synopsis: Make NuGet package.
task nuget package, version, {
	Set-Content z\Package.nuspec @"
<?xml version="1.0"?>
<package xmlns="http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd">
	<metadata>
		<id>$ModuleName</id>
		<version>$Version</version>
		<authors>Roman Kuzmin</authors>
		<owners>Roman Kuzmin</owners>
		<license type="expression">Apache-2.0</license>
		<readme>README.md</readme>
		<projectUrl>https://github.com/nightroman/$ModuleName</projectUrl>
		<description>$Description</description>
		<releaseNotes>https://github.com/nightroman/$ModuleName/blob/main/Release-Notes.md</releaseNotes>
		<tags>FarManager FarNet FSharp CSV XML JSON HTML</tags>
	</metadata>
</package>
"@

	exec { NuGet.exe pack z\Package.nuspec }
}

# Synopsis: Test samples by FarHost.
task testFarHost -If ($Host.Name -ne 'FarHost') {
	Start-Far -Test 0 'ps: Invoke-Build ** tests'
}

# Synopsis: Test samples.
task test testFarHost, {
	Invoke-Build ** tests
}

task . build, clean
