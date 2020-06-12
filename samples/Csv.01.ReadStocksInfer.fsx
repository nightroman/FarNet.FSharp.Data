// http://fsharp.github.io/FSharp.Data/library/CsvProvider.html
// Read data from Stocks.csv and let CsvProvider infer types.
// - Date ~ `DateTime`
// - other values ~ `decimal`
// - mind names with spaces, ``Adj Close``

open FSharp.Data

// infer from the sample
[<Literal>]
let file = __SOURCE_DIRECTORY__ + "/data/Stocks.csv"
type Stocks = CsvProvider<file>

// load data (from the sample in this case)
let data = Stocks.GetSample()

// show data
for row in data.Rows do
    printfn "%O, %M, %M, %M, %M, %M" row.Date row.High row.Low row.Open row.Close row.``Adj Close``
