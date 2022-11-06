// How to use XmlProvider with XSD schema.
// - Far config XML is exported to "%TEMP%/FarConfig.xml".

open FSharp.Data
open System
open System.IO
open System.Diagnostics

let [<Literal>] file = __SOURCE_DIRECTORY__ + "/data/FarConfig.xsd"
type Input = XmlProvider<Schema=file>

// export config once
let source = Environment.ExpandEnvironmentVariables "%TEMP%/FarConfig.xml"
if not (File.Exists(source)) then
    Process.Start("Far.exe", (sprintf "/export %s" source)).WaitForExit()

// load exported XML
let input = Input.Load(source)

// show Associations
for file1 in input.Associations.Filetypes do
    printfn "Mask=%s Description=%s" file1.Mask file1.Description
    for command in file1.Commands do
        if command.Command <> "" then
            printfn "    Type=%i Enabled=%i Command=%s" command.Type command.Enabled command.Command
            printfn ""
