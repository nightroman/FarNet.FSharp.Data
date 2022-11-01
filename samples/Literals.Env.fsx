open FSharp.Data.LiteralProviders

// this way the variable must exist or it does not even compile
let [<Literal>] v1 = Env.OS.Value
printfn "v1=%s" v1

// this way the variable may be missing with empty string value
let [<Literal>] v2 = Env<"OS">.Value
let [<Literal>] v3 = Env<"Missing">.Value
printfn "v2=%s v3=%s" v2 v3
