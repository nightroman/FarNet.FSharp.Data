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
	$vMain = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data"]').Version
	$vCsv = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data.Csv.Core"]').Version
	$vHtml = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data.Html.Core"]').Version
	$vJson = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data.Json.Core"]').Version
	$vWorldBank = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data.WorldBank.Core"]').Version
	$vXml = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data.Xml.Core"]').Version
	$vRU = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data.Runtime.Utilities"]').Version
	$vLP = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data.LiteralProviders"]').Version

	Copy-Item -Destination $ModuleRoot $(
		"$ModuleName.ini"
		#
		"$HOME\.nuget\packages\FSharp.Data\$vMain\lib\netstandard2.0\FSharp.Data.xml"
		"$HOME\.nuget\packages\FSharp.Data\$vMain\typeproviders\fsharp41\netstandard2.0\FSharp.Data.DesignTime.dll"
		#
		"$HOME\.nuget\packages\FSharp.Data.Csv.Core\$vCsv\lib\netstandard2.0\FSharp.Data.Csv.Core.xml"
		#
		"$HOME\.nuget\packages\FSharp.Data.Html.Core\$vHtml\lib\netstandard2.0\FSharp.Data.Html.Core.xml"
		#
		"$HOME\.nuget\packages\FSharp.Data.Json.Core\$vJson\lib\netstandard2.0\FSharp.Data.Json.Core.xml"
		#
		"$HOME\.nuget\packages\FSharp.Data.WorldBank.Core\$vWorldBank\lib\netstandard2.0\FSharp.Data.WorldBank.Core.xml"
		#
		"$HOME\.nuget\packages\FSharp.Data.Xml.Core\$vXml\lib\netstandard2.0\FSharp.Data.Xml.Core.xml"
		#
		"$HOME\.nuget\packages\FSharp.Data.Runtime.Utilities\$vRU\lib\netstandard2.0\FSharp.Data.Runtime.Utilities.xml"
		#
		"$HOME\.nuget\packages\FSharp.Data.LiteralProviders\$vLP\typeproviders\fsharp41\netstandard2.0\DotEnvFile.dll"
		"$HOME\.nuget\packages\FSharp.Data.LiteralProviders\$vLP\typeproviders\fsharp41\netstandard2.0\FSharp.Data.LiteralProviders.DesignTime.dll"
	)

	Set-Location $ModuleRoot
	remove FSharp.Core.dll, cs, de, es, fr, it, ja, ko, pl, pt-BR, ru, tr, zh-Hans, zh-Hant
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
