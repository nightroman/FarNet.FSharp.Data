// How to make typed data (for writing to CSV).

open FSharp.Data
open System

// type from our schema
type MyData = CsvProvider<"Name, Age, Date", Schema="Name (string), Age (int), Date (date option)">

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

test <@ res = """Name,Age,Date
Joe,42,
May,11,2000-01-01T00:00:00.0000000
""" @>
