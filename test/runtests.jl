using TaijaBase
using Test

@testset "TaijaBase.jl" begin

    include("aqua.jl")

    include("parallelization.jl")

    include("samplers.jl")

end
