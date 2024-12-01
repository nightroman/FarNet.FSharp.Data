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

	$xml = [xml](Get-Content "$ModuleName.fsproj" -Raw)
	$vFD = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data"]').Version
	$vLP = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data.LiteralProviders"]').Version

	Copy-Item -Destination $ModuleRoot $(
		"$ModuleName.ini"
		#
		"$HOME\.nuget\packages\FSharp.Data\$vFD\typeproviders\fsharp41\netstandard2.0\FSharp.Data.Csv.Core.xml"
		"$HOME\.nuget\packages\FSharp.Data\$vFD\typeproviders\fsharp41\netstandard2.0\FSharp.Data.DesignTime.dll"
		"$HOME\.nuget\packages\FSharp.Data\$vFD\typeproviders\fsharp41\netstandard2.0\FSharp.Data.Html.Core.xml"
		"$HOME\.nuget\packages\FSharp.Data\$vFD\typeproviders\fsharp41\netstandard2.0\FSharp.Data.Http.xml"
		"$HOME\.nuget\packages\FSharp.Data\$vFD\typeproviders\fsharp41\netstandard2.0\FSharp.Data.Json.Core.xml"
		"$HOME\.nuget\packages\FSharp.Data\$vFD\typeproviders\fsharp41\netstandard2.0\FSharp.Data.Runtime.Utilities.xml"
		"$HOME\.nuget\packages\FSharp.Data\$vFD\typeproviders\fsharp41\netstandard2.0\FSharp.Data.Xml.Core.xml"
		"$HOME\.nuget\packages\FSharp.Data\$vFD\typeproviders\fsharp41\netstandard2.0\FSharp.Data.WorldBank.Core.xml"
		#
		"$HOME\.nuget\packages\FSharp.Data.LiteralProviders\$vLP\typeproviders\fsharp41\netstandard2.0\DotEnvFile.dll"
		"$HOME\.nuget\packages\FSharp.Data.LiteralProviders\$vLP\typeproviders\fsharp41\netstandard2.0\FSharp.Data.LiteralProviders.DesignTime.dll"
	)

	Set-Location $ModuleRoot
	remove cs, de, es, fr, it, ja, ko, pl, pt-BR, ru, tr, zh-Hans, zh-Hant,
	FarNet.FSharp.Data.deps.json,
	FarNet.FSharp.Data.dll,
	FarNet.FSharp.Data.pdb,
	FarNet.FSharp.Data.runtimeconfig.json,
	FSharp.Core.dll
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
		"$ModuleRoot\*.dll"
		"$ModuleRoot\*.ini"
		"$ModuleRoot\*.json"
		"$ModuleRoot\*.xml"
	)

	$result = Get-ChildItem $toModule -Recurse -File -Name | Out-String
	$sample = @'
DotEnvFile.dll
FarNet.FSharp.Data.ini
FSharp.Data.Csv.Core.dll
FSharp.Data.Csv.Core.xml
FSharp.Data.DesignTime.dll
FSharp.Data.dll
FSharp.Data.Html.Core.dll
FSharp.Data.Html.Core.xml
FSharp.Data.Http.dll
FSharp.Data.Http.xml
FSharp.Data.Json.Core.dll
FSharp.Data.Json.Core.xml
FSharp.Data.LiteralProviders.DesignTime.dll
FSharp.Data.LiteralProviders.Runtime.dll
FSharp.Data.Runtime.Utilities.dll
FSharp.Data.Runtime.Utilities.xml
FSharp.Data.WorldBank.Core.dll
FSharp.Data.WorldBank.Core.xml
FSharp.Data.Xml.Core.dll
FSharp.Data.Xml.Core.xml
LICENSE
README.htm
'@
	Assert-SameFile.ps1 -Text $sample $result $env:MERGE
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
