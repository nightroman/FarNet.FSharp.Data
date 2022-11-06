Scripts in this directory are ready to run by `FarNet.FSharpFar` or its `fsx.exe`.
The configuration file [.fs.ini](.fs.ini) provides the required references.

For running by `fsi` scripts need directives like

```fsharp
#r @"C:\Bin\Far\x64\FarNet\Lib\FarNet.FSharp.Data\FSharp.Data.dll"
#r @"C:\Bin\Far\x64\FarNet\Lib\FarNet.FSharp.Data\FSharp.Data.LiteralProviders.Runtime.dll"
```

Some scripts use [FarNet.FSharp.Unquote](https://github.com/nightroman/FarNet.FSharp.Unquote) for testing.

**See also**

- [CsvProvider](http://fsprojects.github.io/FSharp.Data/library/CsvProvider.html)
- [CSV schema supported types](https://github.com/fsprojects/FSharp.Data/blob/main/src/Csv/CsvInference.fs)
- [Parsing CSV schema strings](http://fssnip.net/te)
- [HtmlProvider](https://fsprojects.github.io/FSharp.Data/library/HtmlProvider.html)
- [JsonProvider](https://fsprojects.github.io/FSharp.Data/library/JsonProvider.html)
- [XmlProvider](https://fsprojects.github.io/FSharp.Data/library/XmlProvider.html)
