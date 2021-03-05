// http://fsharp.github.io/FSharp.Data/library/CsvProvider.html
// Read data from Stocks.csv and let CsvProvider infer types.
// - Date ~ `DateTime`, Volume ~ `int`, others ~ `decimal`
// - mind names with spaces, ``Adj Close``

open FSharp.Data

// infer from the sample
type Stocks = CsvProvider<"data/Stocks.csv", ResolutionFolder=__SOURCE_DIRECTORY__>

// load data (from the sample in this case)
let data = Stocks.GetSample()

// show data
for row in data.Rows do
    printfn "%O, %M, %M, %M, %M, %i, %M" row.Date row.High row.Low row.Open row.Close row.Volume row.``Adj Close``
