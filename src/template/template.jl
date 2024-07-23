using PkgTemplates: PkgTemplates, @with_kw_noshow, @plugin, Plugin, default_file, Template, pkg_name, render_file, combined_view, tags, gen_file
const TAIJA_TEMPLATE_DIR = Ref{String}(joinpath(dirname(dirname(pathof(TaijaBase))), "templates"))

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
            julia=v"1.10",
            plugins=[
                BlueStyleBadge(),
                Citation(),
                Codecov(file=joinpath(TAIJA_TEMPLATE_DIR[], ".codecov.yml")),
                Documenter{GitHubActions}(make_jl=Quarto().make_jl),
                Formatter(style="blue"),
                License(),
                Quarto(),
                RegisterAction(),
            ]
        )
    end
end