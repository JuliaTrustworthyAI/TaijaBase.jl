using PkgTemplates

"""
    pkg_template(; user::String, authors::String, dir::String="~")

Create a new package template with the following plugins:

- `BlueStyleBadge`
- `Citation`
- `Codecov`
- `Documenter{GitHubActions}`
- `Develop`
- `Formatter(style="blue")`
- `License`
- `PkgBenchmark`
- `RegisterAction`

# Arguments

- `authors::String`: The authors of the package.
- `dir::String`: The directory where the package will be created. Default is `~`.

# Example

```julia
pkg_template(authors="Jane Doe", dir="~/Documents")
```

"""
function pkg_template(; authors::String, dir::String="~")
    @eval begin
        using PkgTemplates
        Template(;
            user="JuliaTrustworthyAI",
            dir=$dir,
            authors=$authors,
            julia=v"1.6",
            plugins=[
                BlueStyleBadge(),
                Citation(),
                Codecov(),
                Documenter{GitHubActions}(),
                Develop(),
                Formatter(style="blue"),
                License(),
                PkgBenchmark(),
                RegisterAction(),
            ]
        )
    end
end