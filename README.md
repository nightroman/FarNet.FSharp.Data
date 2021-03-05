[NuGet]: https://www.nuget.org/packages/FarNet.FSharp.Data
[GitHub]: https://github.com/nightroman/FarNet.FSharp.Data
[/samples]: https://github.com/nightroman/FarNet.FSharp.Data/tree/master/samples
[FSharp.Data]: https://fsprojects.github.io/FSharp.Data/
[FarNet.FSharpFar]: https://github.com/nightroman/FarNet/tree/master/FSharpFar

# FarNet.FSharp.Data

[FSharp.Data] package for [FarNet.FSharpFar]

## Package

The NuGet package [FarNet.FSharp.Data][NuGet] is designed for [FarNet.FSharpFar].
To install FarNet packages, follow [these steps](https://github.com/nightroman/FarNet#readme).

Once installed, the package is portable with Far Manager and available for F# scripts.

## F# scripts

In your F# script directory create the configuration `*.fs.ini`:

```ini
[use]
%FARHOME%\FarNet\Lib\FarNet.FSharp.Data\FarNet.FSharp.Data.ini
```

Scripts normally start with:

```fsharp
open FSharp.Data
```

This is it. See [/samples].
