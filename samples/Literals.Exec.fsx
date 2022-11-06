open FSharp.Data.LiteralProviders

let [<Literal>] currentBranch = Exec<"git", "branch --show-current", Directory=__SOURCE_DIRECTORY__>.Output
let [<Literal>] someOutput = Exec<"cmd", "/c echo bar">.Output
printfn "%s %s" currentBranch someOutput

// test

open Swensen.Unquote

test <@ currentBranch.Length > 0 @>
test <@ someOutput = "bar" @>
