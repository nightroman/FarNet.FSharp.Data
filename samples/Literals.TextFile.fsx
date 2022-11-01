open FSharp.Data.LiteralProviders

let [<Literal>] FARHOME = Env.FARHOME.Value
let [<Literal>] path = FARHOME + "/Far.exe.example.ini"
let [<Literal>] text = TextFile<path>.Text
printfn "%s" text
