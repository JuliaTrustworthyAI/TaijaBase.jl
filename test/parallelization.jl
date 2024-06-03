using TaijaBase: parallelize, vectorize_collection

@testset "Parallelization" begin
    @test vectorize_collection([1, 2, 3]) == [1, 2, 3]
    @test vectorize_collection([1 2; 3 4]) == [[1 2; 3 4]]
    @test vectorize_collection(zip([1, 2, 3], [4, 5, 6])) == [1, 2, 3]
    @test parallelize(nothing, x -> x^2, [1, 2, 3]) == [1, 4, 9]
end
