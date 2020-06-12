// http://fsharp.github.io/FSharp.Data/library/HtmlProvider.html
// How to get Far Manager stable and nightly builds info.

open FSharp.Data

type Data = HtmlProvider<"https://farmanager.com/download.php?l=en">
let data = Data().Lists

printfn "Stable builds"

data.``Stable builds``.Values
|> Seq.iter (printfn "%A")

printfn "Nightly builds"

data.``Nightly builds full changelog``.Values
|> Seq.iter (printfn "%A")
