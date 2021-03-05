// http://fsharp.github.io/FSharp.Data/library/JsonProvider.html
// Show GitHub repository issues using JsonProvider.
// How to get issues : https://developer.github.com/v3/issues/#list-repository-issues
// This sample query : https://api.github.com/repos/nightroman/Helps/issues?state=all
// (saved to Issues.json)

open FSharp.Data

type Data = JsonProvider<"data/Issues.json", ResolutionFolder=__SOURCE_DIRECTORY__>
let data = Data.GetSamples()

let trim (s: string) n =
    let s = s.Trim()
    if s.Length <= n then s else s.Substring(0, n) + "..."

for x in data do
    printfn "%s" ("".PadLeft(80, '-'))
    printfn "@%s" x.User.Login
    printfn "%O" x.CreatedAt
    printfn ""
    printfn "%s" x.Title
    printfn "%s" x.HtmlUrl
    printfn ""
    printfn "%s" (trim x.Body 200)
    printfn ""
