// How to read XML from files using XSD schema.

open FSharp.Data

// infer types using XSD
let [<Literal>] schema = __SOURCE_DIRECTORY__ + "/data/Packages.xsd"
type Data = XmlProvider<Schema=schema>

// load data from a file
let file = __SOURCE_DIRECTORY__ + "/data/Packages.xml"
let data = Data.Load(file)

let show (data: Data.Packages) =
    printfn "clean = %A; saved = %A" data.Clean data.Saved

    for package in data.Packages do
        printfn "package id = %s name = %s" package.Id package.Name
        for version in package.Versions do
            printfn "version %s" version.Name
            for log in version.Logs do
                printfn "log d = %A n = %i" log.D log.N

show data
