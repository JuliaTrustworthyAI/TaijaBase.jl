module TaijaBase

export AbstractParallelizer, pkg_template

include("parallelization/base.jl")
include("deprecated.jl")
include("template/template.jl")

end
