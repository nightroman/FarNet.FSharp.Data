Scripts in this directory are ready to run by `FarNet.FSharpFar` or its `fsx.exe`.
The configuration file [.fs.ini](.fs.ini) provides the required references.

For running by `fsi.exe` scripts need manually added `#r` directives like

```fsharp
#r "System.Xml.Linq"
#r @"C:\Bin\Far\x64\FarNet\Lib\FarNet.FSharp.Data\FSharp.Data.dll"
```

***

**See also**

- [CSV schema supported types](https://github.com/fsharp/FSharp.Data/blob/master/src/Csv/CsvInference.fs)
- [Parsing CSV schema strings](http://fssnip.net/te)
