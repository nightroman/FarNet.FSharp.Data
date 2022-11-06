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
printfn "%A" data

// test

open Swensen.Unquote

test <@ data.Bool1 = true @>
test <@ data.Bool2 = false @>
test <@ data.Date1 = DateTime.Parse("1999-11-11") @>
test <@ data.Date2 = DateTime.Parse("1999-1-1 1:2:3") @>
test <@ data.Decimal = 1m @>
test <@ data.Float = 1.0 @>
test <@ data.Guid = Guid "e3ad1cfb-ab1d-4fde-80ca-4eb99a7c0512" @>
test <@ data.Int32 = 1 @>
test <@ data.Int64 = 9876543210L @>
