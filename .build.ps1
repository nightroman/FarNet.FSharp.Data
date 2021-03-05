<#
.Synopsis
	Build script, https://github.com/nightroman/Invoke-Build
#>

param(
	$Configuration = (property Configuration Release)
)

Set-StrictMode -Version 2
$ModuleName = 'FarNet.FSharp.Data'
$env:FarDevHome = $FarDevHome = if (Test-Path 'C:\Bin\Far\x64') {'C:\Bin\Far\x64'} else {''}

# Synopsis: Remove temp files.
task Clean {
	remove src\bin, src\obj, README.htm, *.nupkg, z
}

# Synopsis: Build and Post (post build target).
task Build {
	Set-Location src
	exec {dotnet build -c $Configuration}
}

# Synopsis: Post build target. Copy stuff.
task Post -If:$FarDevHome {
	$to = "$FarDevHome\FarNet\Lib\$ModuleName"

	$xml = [xml](Get-Content "src\$ModuleName.fsproj")
	$node = $xml.SelectSingleNode('Project/ItemGroup/PackageReference[@Include="FSharp.Data"]')
	$from = "$HOME\.nuget\packages\FSharp.Data\$($node.Version)"

	Copy-Item -Destination $to $(
		"src\$ModuleName.ini"
		"$from\lib\netstandard2.0\FSharp.Data.xml"
		"$from\typeproviders\fsharp41\netstandard2.0\FSharp.Data.DesignTime.dll"
	)
}

# Get version from release notes.
function Get-Version {
	switch -Regex -File Release-Notes.md {'##\s+v(\d+\.\d+\.\d+)' {return $Matches[1]} }
}

# Synopsis: Set $script:Version.
task Version {
	($script:Version = Get-Version)
}

# Synopsis: Convert markdown to HTML.
task Markdown {
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
task Package -If:$FarDevHome Markdown, {
	remove z
	$toModule = mkdir "z\tools\FarHome\FarNet\Lib\$ModuleName"
	$fromModule = "$FarDevHome\FarNet\Lib\$ModuleName"

	Copy-Item -Destination $toModule @(
		'README.htm'
		'LICENSE'
		"$fromModule\FarNet.FSharp.Data.ini"
		"$fromModule\FSharp.Data.dll"
		"$fromModule\FSharp.Data.xml"
		"$fromModule\FSharp.Data.DesignTime.dll"
	)
}

# Synopsis: Make NuGet package.
task NuGet -If:$FarDevHome Package, Version, {
	$text = @'
FSharp.Data package for FarNet.FSharpFar

---

The package is designed for FarNet.FSharpFar.
To install FarNet packages, follow these steps:

https://raw.githubusercontent.com/nightroman/FarNet/master/Install-FarNet.en.txt

---
'@
	# nuspec
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
		<summary>$text</summary>
		<description>$text</description>
		<releaseNotes>https://github.com/nightroman/FarNet.FSharp.Data/blob/master/Release-Notes.md</releaseNotes>
		<tags>FarManager FarNet FSharp CSV XML JSON HTML</tags>
	</metadata>
</package>
"@
	# pack
	exec { NuGet.exe pack z\Package.nuspec }
}

# Synopsis: Test samples.
task Test {
	Invoke-Build ** tests
}

task . Build, Test, Clean
