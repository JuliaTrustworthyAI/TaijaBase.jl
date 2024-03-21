using TaijaBase: parallelize, vectorize_collection, ProcessStyle, IsParallel, parallelizable

foo(x) = x^2
bar(x) = x^2

@testset "Parallelization" begin
    @test vectorize_collection([1, 2, 3]) == [1, 2, 3]
    @test vectorize_collection([1 2; 3 4]) == [[1 2; 3 4]]
    @test vectorize_collection(zip([1, 2, 3], [4, 5, 6])) == [1, 2, 3]
    @test parallelize(nothing, x -> x^2, [1, 2, 3]) == [1, 4, 9]
    ProcessStyle(::Type{<:typeof(foo)}) = IsParallel()
    println(parallelizable(foo))
    @test parallelizable(foo) == true
    ProcessStyle(::Type{<:typeof(bar)}) = NotParallel()
    @test parallelizable(bar) == false
end