// Read untyped data from Stocks.csv.
// - all data are strings
// - get by values GetColumn
// - or by "?" (use `open FSharp.Data.CsvExtensions`)

open FSharp.Data
open FSharp.Data.CsvExtensions

let file = __SOURCE_DIRECTORY__ + "/data/Stocks.csv"
let data = CsvFile.Load(file)

// show data using GetColumn
for row in data.Rows do
    printfn "%s, %s, %s" (row.GetColumn "Date") (row.GetColumn "High") (row.GetColumn "Low")

// show data using "?"
for row in data.Rows do
    printfn "%s, %s, %s" row?Date row?High row?Low

// test

open Swensen.Unquote

let row = data.Rows |> Seq.head
test <@ (row?Date, row?High, row?Low) = ("2012-01-27", "29.53", "29.17") @>
