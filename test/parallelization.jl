using TaijaBase: parallelize, vectorize_collection, ProcessStyle, IsParallel, parallelizable

ProcessStyle(::Type{<:typeof(sum)}) = IsParallel()
ProcessStyle(::Type{<:typeof(prod)}) = NotParallel()

@testset "Parallelization" begin
    @test vectorize_collection([1, 2, 3]) == [1, 2, 3]
    @test vectorize_collection([1 2; 3 4]) == [[1 2; 3 4]]
    @test vectorize_collection(zip([1, 2, 3], [4, 5, 6])) == [1, 2, 3]
    @test parallelize(nothing, x -> x^2, [1, 2, 3]) == [1, 4, 9]
    @test parallelizable(sum) == true
    @test parallelizable(Base.product) == false
end