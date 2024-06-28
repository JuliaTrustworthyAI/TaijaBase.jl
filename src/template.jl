using PkgTemplates: PkgTemplates, @with_kw_noshow, @plugin, Plugin, default_file, Template, pkg_name, render_file, combined_view, tags, gen_file
const TAIJA_TEMPLATE_DIR = Ref{String}(joinpath(dirname(dirname(pathof(TaijaBase))), "templates"))

@plugin struct Quarto <: Plugin
    index_qmd::String = joinpath(TAIJA_TEMPLATE_DIR[], "index.qmd")
    readme_qmd::String = joinpath(TAIJA_TEMPLATE_DIR[], "README.qmd")
    config::String = joinpath(TAIJA_TEMPLATE_DIR[], "_quarto.yml")
end

PkgTemplates.view(p::Quarto, t::Template, pkg::AbstractString) = Dict(
    "AUTHORS" => join(t.authors, ", "),
    "PKG" => pkg,
    "REPO" => "$(t.host)/$(t.user)/$pkg.jl",
    "USER" => t.user,
)

function PkgTemplates.hook(p::Quarto, t::Template, pkg_dir::AbstractString)

    pkg = pkg_name(pkg_dir)
    docs_dir = joinpath(pkg_dir, "docs")
    assets_dir = joinpath(docs_dir, "src", "assets")
    ispath(assets_dir) || mkpath(assets_dir)

    readme = render_file(p.readme_qmd, combined_view(p, t, pkg), tags(p))
    gen_file(joinpath(pkg_dir, "README.qmd"), readme)

    index = render_file(p.index_qmd, combined_view(p, t, pkg), tags(p))
    gen_file(joinpath(docs_dir, "src", "index.qmd"), index)

    config = render_file(p.config, combined_view(p, t, pkg), tags(p))
    gen_file(joinpath(pkg_dir, "_quarto.yml"), config)
end

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
                Codecov(file=joinpath(TAIJA_TEMPLATE_DIR[], ".codecov.yml")),
                Documenter{GitHubActions}(),
                Formatter(style="blue"),
                License(),
                Quarto(),
                RegisterAction(),
            ]
        )
    end
end

