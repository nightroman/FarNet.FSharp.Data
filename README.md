[/samples]: https://github.com/nightroman/FarNet.FSharp.Data/tree/main/samples
[FarNet.FSharpFar]: https://github.com/nightroman/FarNet/tree/master/FSharpFar
[FSharp.Data]: https://fsprojects.github.io/FSharp.Data/
[FSharp.Data.LiteralProviders]: https://github.com/tarmil/fsharp.data.literalproviders

# FarNet.FSharp.Data

This package is designed for [FarNet.FSharpFar] and includes

- [FSharp.Data]
- [FSharp.Data.LiteralProviders]

## Installation

- Far Manager
- Package [FarNet](https://www.nuget.org/packages/FarNet)
- Package [FarNet.FSharpFar](https://www.nuget.org/packages/FarNet.FSharpFar)
- Package [FarNet.FSharp.Data](https://www.nuget.org/packages/FarNet.FSharp.Data)

How to install and update FarNet and modules:\
https://github.com/nightroman/FarNet#readme

Once installed, the package is portable with Far Manager and available for F# scripts.

## F# scripts

In your F# script directory create the configuration `*.fs.ini`:

```ini
[use]
%FARHOME%\FarNet\Lib\FarNet.FSharp.Data\FarNet.FSharp.Data.ini
```

Scripts normally use one of the following:

```fsharp
open FSharp.Data
open FSharp.Data.LiteralProviders
```

This is it. See [/samples].

## See also

- [Release Notes](https://github.com/nightroman/FarNet.FSharp.Data/blob/main/Release-Notes.md)
- [FSharp.Data]
- [FSharp.Data.LiteralProviders]
