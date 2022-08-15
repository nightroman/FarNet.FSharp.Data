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

	$xml = [xml](Get-Content "$ModuleName.fsproj")
	$node = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data"]')
	$from = "$HOME\.nuget\packages\FSharp.Data\$($node.Version)"

	Copy-Item -Destination $ModuleRoot $(
		"$ModuleName.ini"
		"$from\lib\netstandard2.0\FSharp.Data.dll"
		"$from\lib\netstandard2.0\FSharp.Data.xml"
		"$from\typeproviders\fsharp41\netstandard2.0\FSharp.Data.DesignTime.dll"
	)
}

# Get version from release notes.
function Get-Version {
	switch -Regex -File Release-Notes.md {'##\s+v(\d+\.\d+\.\d+)' {return $Matches[1]} }
}

# Synopsis: Set $script:Version.
task version {
	($script:Version = Get-Version)
}

# Synopsis: Convert markdown to HTML.
task markdown {
	assert (Test-Path $env:MarkdownCss)
	exec { pandoc.exe @(
		'README.md'
		'--output=README.htm'
		'--from=gfm'
		'--self-contained', "--css=$env:MarkdownCss"
		'--standalone', "--metadata=pagetitle=$ModuleName"
	)}
}

# Synopsis: Collect package files.
task package markdown, {
	remove z
	$toModule = mkdir "z\tools\FarHome\FarNet\Lib\$ModuleName"

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
	$description = @'
FSharp.Data package for FarNet.FSharpFar

---

The package is designed for FarNet.FSharpFar.
To install FarNet packages, follow these steps:

https://github.com/nightroman/FarNet#readme
'@

	Set-Content z\Package.nuspec @"
<?xml version="1.0"?>
<package xmlns="http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd">
	<metadata>
		<id>$ModuleName</id>
		<version>$Version</version>
		<authors>Roman Kuzmin</authors>
		<owners>Roman Kuzmin</owners>
		<projectUrl>https://github.com/nightroman/$ModuleName</projectUrl>
		<license type="expression">Apache-2.0</license>
		<requireLicenseAcceptance>false</requireLicenseAcceptance>
		<description>$description</description>
		<releaseNotes>https://github.com/nightroman/FarNet.FSharp.Data/blob/main/Release-Notes.md</releaseNotes>
		<tags>FarManager FarNet FSharp CSV XML JSON HTML</tags>
	</metadata>
</package>
"@

	exec { NuGet.exe pack z\Package.nuspec }
}

# Synopsis: Test samples.
task test {
	Invoke-Build ** tests
}

task . build, test, clean
