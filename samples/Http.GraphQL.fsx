// How to query GraphQL using Http.Request

open FSharp.Data
open System
open System.Text.Json

let token = Environment.GetEnvironmentVariable("NEXAR_TOKEN")

let query = """
query {
  desUserByAuth {
    globalUserId
    userName
    email
  }
}
"""

let body = JsonSerializer.Serialize {|
    query = query
|}

let res = Http.Request("https://api.nexar.com/graphql", httpMethod = "POST", body = TextRequest body, headers = [
    ("Content-Type", "application/json")
    ("Authorization", $"Bearer {token}")
])

printfn $"{res}"

// test

open Swensen.Unquote

test <@ res.Body.ToString().Contains "roman.kuzmin" @>
