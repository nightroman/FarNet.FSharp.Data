// Give CsvProvider our schema and then read Stocks.csv.
// - names are capitalized, even with our schema
// - we use `float` instead of default `decimal`
// - we rename "Adj Close" to "Adjacent"
// - we exclude the field "Volume"
// - types follow our schema

open FSharp.Data

// provide our schema
type Stocks = CsvProvider<"date (date), high (float), low (float), open (float), close (float), adjacent (float)">

// load data file
let file = __SOURCE_DIRECTORY__ + "/data/Stocks.csv"
let data = Stocks.Load(file)

// show data
for row in data.Rows do
    printfn "%O, %f, %f, %f, %f, %f" row.Date row.High row.Low row.Open row.Close row.Adjacent

// test

open Swensen.Unquote

let row = data.Rows |> Seq.head
test <@ (row.High, row.Low, row.Open, row.Close, row.Adjacent) = (29.45, 29.53, 29.17, 29.23, 44187700) @>
