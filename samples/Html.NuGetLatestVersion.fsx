// http://fsharp.github.io/FSharp.Data/library/HtmlProvider.html
// How to get the latest info for NuGet packages.

open FSharp.Data

// static
type Data = HtmlProvider<"https://www.nuget.org/packages/FarNet">
let data1 = Data().Tables.``Version History``

// dynamic
let data2 = (Data.Load "https://www.nuget.org/packages/Mdbc").Tables.``Version History``

[ data1.Rows.[0]; data2.Rows.[0] ]
|> List.iter (fun x ->
    printfn "Version = %s, Downloads = %M, Date = %O" x.Version x.Downloads x.``Last updated``
)
