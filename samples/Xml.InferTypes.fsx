// http://fsharp.github.io/FSharp.Data/library/XmlProvider.html
// How XmlProvider infers XML data types.

open FSharp.Data
open System

type Data = XmlProvider<"""
<root
    bool1 = "true"
    bool2 = "FALSE"
    date1 = "1999-11-11"
    date2 = "1999-1-1 1:2:3"
    decimal = "1.0"
    float = "1e0"
    guid = "e3ad1cfb-ab1d-4fde-80ca-4eb99a7c0512"
    int32 = "1"
    int64 = "9876543210"
/>
""">

let data = Data.GetSample()

let test value expected =
    let n = value.GetType().Name
    printfn "%s %A" n value
    if n <> expected then failwithf "Expected type %s." expected

test data.Bool1 "Boolean"
test data.Bool2 "Boolean"
test data.Date1 "DateTime"
test data.Date2 "DateTime"
test data.Decimal "Decimal"
test data.Float "Double"
test data.Guid "Guid"
test data.Int32 "Int32"
test data.Int64 "Int64"
