// How to make typed data (for writing to CSV) without headers.
// This case is useful for appending to CSV format log files.
// - schema field names may be dummy

open FSharp.Data
open System

// type from our schema
type MyData = CsvProvider<Schema="x (string), x (int), x (date option)", HasHeaders=false>

// make rows
let rows = seq {
    MyData.Row("Joe", 42, None)
    MyData.Row("May", 11, Some (DateTime.Parse("2000-01-01")))
}

// save data (to string here, use Save() to files)
let res = (new MyData(rows)).SaveToString()
printfn "%s" res

// test

open Swensen.Unquote

test <@ res = """Joe,42,
May,11,2000-01-01T00:00:00.0000000
""" @>
