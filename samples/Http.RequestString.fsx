// How to invoke REST GET using Http.RequestString

open FSharp.Data
open System

let token = Environment.GetEnvironmentVariable("GITHUB_TOKEN")

let res = Http.RequestString("https://api.github.com/user", headers = [
    ("Authorization", $"Bearer {token}")
    ("User-Agent", "nightroman")
])

printfn $"{res}"

// test

open Swensen.Unquote

test <@ res.Contains "\"login\":\"nightroman\"" @>
