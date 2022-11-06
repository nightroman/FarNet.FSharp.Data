// TSV sample with schema

open FSharp.Data

type Data = CsvProvider<"Gain(int)\tRank(int)\tAge(int)\tMode(string)\tPath(string)">

let data = Data.Load(__SOURCE_DIRECTORY__ + "/data/TsvSample1.txt")

for row in data.Rows do
    printfn "%i, %i, %i, %s, %s" row.Gain row.Rank row.Age row.Mode row.Path

// test

open Swensen.Unquote

let row = data.Rows |> Seq.head
test <@ (row.Gain, row.Rank, row.Age, row.Mode, row.Path) = (2, 6, 5, "File", @"...\file.txt") @>
