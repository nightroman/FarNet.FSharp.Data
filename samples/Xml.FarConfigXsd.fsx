// http://fsharp.github.io/FSharp.Data/library/XmlProvider.html
// How to use XmlProvider with XSD schema.
// - Far config XML is exported to "%TEMP%/FarConfig.xml".

open FSharp.Data
open System
open System.IO
open System.Diagnostics

type Input = XmlProvider<Schema="data/FarConfig.xsd", ResolutionFolder=__SOURCE_DIRECTORY__>

// export config once
let source = Environment.ExpandEnvironmentVariables "%TEMP%/FarConfig.xml"
if not (File.Exists(source)) then
    Process.Start("Far.exe", (sprintf "/export %s" source)).WaitForExit()

// load exported XML
let input = Input.Load(source)

// show Associations
for file in input.Associations.Filetypes do
    printfn "Mask=%s Description=%s" file.Mask file.Description
    for command in file.Commands do
        if command.Command <> "" then
            printfn "    Type=%i Enabled=%i Command=%s" command.Type command.Enabled command.Command
            printfn ""
