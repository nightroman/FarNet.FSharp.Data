// TSV sample, note that .txt extension is fine

open FSharp.Data

// infer from sample
[<Literal>]
let file = __SOURCE_DIRECTORY__ + "/data/TsvSample1.txt"
type Data = CsvProvider<file>

// load data (from sample in this case)
let data = Data.GetSample()

// show data
printfn "%A" data.Rows
for row in data.Rows do
    printfn "%i, %i, %i, %s, %s" row.Gain row.Rank row.Age row.Mode row.Path
