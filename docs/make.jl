using TaijaBase
using Documenter

DocMeta.setdocmeta!(TaijaBase, :DocTestSetup, :(using TaijaBase); recursive=true)

makedocs(;
    modules=[TaijaBase],
    authors="Patrick Altmeyer",
    sitename="TaijaBase.jl",
    format=Documenter.HTML(;
        canonical="https://JuliaTrustworthyAI.github.io/TaijaBase.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaTrustworthyAI/TaijaBase.jl",
    devbranch="main",
)
