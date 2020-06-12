// http://fsharp.github.io/FSharp.Data/library/CsvProvider.html
// How to make typed data (for writing to CSV) without headers.
// This case is useful for appending to CSV format log files.
// - note, schema field names may be dummy

open FSharp.Data
open System

// type from our schema
type MyData = CsvProvider<Schema="x (string), x (int), x (date option)", HasHeaders=false>

// make rows
let rows = seq {
    MyData.Row ("Joe", 42, None)
    MyData.Row ("May", 11, Some DateTime.Now)
}

// save data (to string in this sample, use Save() to save to a file)
(new MyData(rows)).SaveToString()
|> printfn "%s"
