open FSharp.Data.LiteralProviders

let [<Literal>] currentBranch = Exec<"git", "branch --show-current", Directory=__SOURCE_DIRECTORY__>.Output

printfn "%s" currentBranch
