// Read data from Stocks.csv and let CsvProvider infer types.
// - Date ~ `DateTime`, Volume ~ `int`, others ~ `decimal`
// - mind names with spaces, ``Adj Close``

open FSharp.Data

// infer from the sample
let [<Literal>] file = __SOURCE_DIRECTORY__ + "/data/Stocks.csv"
type Stocks = CsvProvider<file>

// load data (from the sample in this case)
let data = Stocks.GetSample()

// show data
for row in data.Rows do
    printfn "%O, %M, %M, %M, %M, %i, %M" row.Date row.High row.Low row.Open row.Close row.Volume row.``Adj Close``

// test

open Swensen.Unquote

let row = data.Rows |> Seq.head
test <@ (row.High, row.Low, row.Open, row.Close, row.Volume, row.``Adj Close``) = (29.53m, 29.17m, 29.45m, 29.23m, 44187700, 29.23m) @>
