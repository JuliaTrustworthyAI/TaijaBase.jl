using Distributions
using MLJBase
using TaijaBase.Samplers

# Data:
nobs = 2000
X, y = make_circles(nobs, noise=0.1, factor=0.5)
Xmat = Float32.(permutedims(matrix(X)))
X = table(permutedims(Xmat))
batch_size = Int(round(nobs / 10))

# Distributions:
𝒟x = Normal()
𝒟y = Categorical(ones(2) ./ 2)

@testset "Samplers" begin
    @testset "ConditionalSampler" begin
        sampler = ConditionalSampler(𝒟x, 𝒟y, input_size=size(Xmat)[1:end-1], batch_size=batch_size)
        @testset "constructor" begin
            @testset "default" begin
                @test sampler isa ConditionalSampler
                @test sampler isa AbstractSampler
            end
        end
    end
end