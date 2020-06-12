// http://fsharp.github.io/FSharp.Data/library/XmlProvider.html
// How to read XML from files and let XmlProvider infer types.

open FSharp.Data

// infer type from a sample file
[<Literal>]
let file = __SOURCE_DIRECTORY__ + "/data/Packages.xml"
type Data = XmlProvider<file>

// data from the sample
let data1 = Data.GetSample()

// load data from a file (same in this sample)
let data2 = Data.Load(file)

let show (data: Data.Packages) =
    printfn "clean = %A; saved = %A" data.Clean data.Saved

    for package in data.Packages do
        printfn "package id = %s name = %s" package.Id package.Name
        for version in package.Versions do
            printfn "version %s" version.Name
            for log in version.Logs do
                printfn "log d = %A n = %i" log.D log.N

show data1
show data2
