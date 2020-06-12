// http://fsharp.github.io/FSharp.Data/library/XmlProvider.html
// How XmlProvider infers XML names.

open FSharp.Data

type Data = XmlProvider<"""
<data>
  <item1 name="item1-1"/>
  <item1 name="item1-2"/>
  <item2 name="item2-1"/>
  <item2 name="item2-2"/>
  <item3 name="item3"/>
</data>
""">

let data = Data.GetSample()

// Generated plural name from 2+ items.
data.Item1s
|> printfn "%A"

// Another plural name from 2+ items.
data.Item2s
|> printfn "%A"

// Capitalized single name of 1 item.
data.Item3
|> printfn "%A"
