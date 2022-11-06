// TSV sample, note that .txt extension is fine

open FSharp.Data

// infer from sample
let [<Literal>] file = __SOURCE_DIRECTORY__ + "/data/TsvSample1.txt"
type Data = CsvProvider<file>

// load data (from sample in this case)
let data = Data.GetSample()

// show data
printfn "%A" data.Rows
for row in data.Rows do
    printfn "%i, %i, %i, %s, %s" row.Gain row.Rank row.Age row.Mode row.Path

// test

open Swensen.Unquote

let row = data.Rows |> Seq.head
test <@ (row.Gain, row.Rank, row.Age, row.Mode, row.Path) = (2, 6, 5, "File", @"...\file.txt") @>
