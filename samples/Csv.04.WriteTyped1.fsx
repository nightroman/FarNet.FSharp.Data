// http://fsharp.github.io/FSharp.Data/library/CsvProvider.html
// How to make typed data (for writing to CSV).

open FSharp.Data
open System

// type from our schema
type MyData = CsvProvider<"Name, Age, Date", Schema="Name (string), Age (int), Date (date option)">

// make rows
let rows = seq {
    MyData.Row ("Joe", 42, None)
    MyData.Row ("May", 11, Some DateTime.Now)
}

// save data (to string in this sample, use Save() to save to a file)
(new MyData(rows)).SaveToString()
|> printfn "%s"
