// http://fsharp.github.io/FSharp.Data/library/CsvProvider.html
// Give CsvProvider our schema and then read Stocks.csv.
// - names are capitalized, even with the schema
// - we use `float` instead of default `decimal`
// - we rename "Adj Close" to "Adjacent"
// - all field types follow our schema

open FSharp.Data

// provide our schema
type Stocks = CsvProvider<"date (date), high (float), low (float), open (float), close (float), adjacent (float)">

// load data file
let file = __SOURCE_DIRECTORY__ + "/data/Stocks.csv"
let data = Stocks.Load(file)

// show data
for row in data.Rows do
    printfn "%O, %f, %f, %f, %f, %f" row.Date row.High row.Low row.Open row.Close row.Adjacent
