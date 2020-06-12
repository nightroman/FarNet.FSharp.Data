// http://fsharp.github.io/FSharp.Data/library/CsvProvider.html
// Read untyped data from Stocks.csv.
// - all data are strings
// - get by values GetColumn
// - or by "?" (requires `open FSharp.Data.CsvExtensions`)

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
