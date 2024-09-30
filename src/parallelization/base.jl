"An abstract type for parallelizers. This type is owned by the `TaijaBase` module to allow shipping it to packages that depend on `TaijaBase`, without having to depend on the `TaijaParallel` module. See also [`parallelize`](@ref) for a detailed explanation."
abstract type AbstractParallelizer end

include("functions.jl")