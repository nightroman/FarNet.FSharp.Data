// Show GitHub repository issues using JsonProvider.
// How to get issues : https://docs.github.com/en/rest/issues/issues#list-repository-issues
// This sample query : https://api.github.com/repos/nightroman/Helps/issues?state=all
// (saved to Issues.json)

open FSharp.Data

let [<Literal>] file = __SOURCE_DIRECTORY__ + "/data/Issues.json"
type Data = JsonProvider<file>
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

// test

open Swensen.Unquote

let res = data |> Seq.head
test <@ res.User.Login = "mattmcnabb" @>
