using TaijaBase
using Documenter

DocMeta.setdocmeta!(TaijaBase, :DocTestSetup, :(using TaijaBase); recursive=true)

makedocs(;
    modules=[TaijaBase],
    authors="Patrick Altmeyer",
    sitename="TaijaBase.jl",
    format=Documenter.HTML(;
        canonical="https://pat-alt.github.io/TaijaBase.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/pat-alt/TaijaBase.jl",
    devbranch="main",
)
