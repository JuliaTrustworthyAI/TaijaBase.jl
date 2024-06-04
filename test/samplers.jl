using Distributions
using MLJBase
using Optimisers
using TaijaBase.Samplers: ImproperSGLD, SGLD, JointSampler, ConditionalSampler, UnconditionalSampler, AbstractSampler

@testset "Samplers" begin

    f(x) = @.(2x + 1)  # dummy model
    rule = ImproperSGLD()

    all_samplers = Dict(
        "Conditional" => ConditionalSampler,
        "Unconditional" => UnconditionalSampler,
        "Joint" => JointSampler,
    )

    for (name, Sampler) in all_samplers
        @testset "$name" begin
            # Data:
            nobs = 2000
            X, y = make_circles(nobs, noise = 0.1, factor = 0.5)
            Xmat = Float32.(permutedims(matrix(X)))
            X = table(permutedims(Xmat))
            batch_size = Int(round(nobs / 10))

            # Distributions:
            𝒟x = Normal()
            𝒟y = Categorical(ones(2) ./ 2)

            sampler = Sampler(
                𝒟x,
                𝒟y,
                input_size = size(Xmat)[1:end-1],
                batch_size = batch_size,
            )
            @test sampler isa AbstractSampler

            X̂ = sampler(f, rule; n_samples=10)
            @test size(X̂, 2) == 10
        end
    end

    @testset "Optimizers (Bayesian Inference Example)" begin
        # Example from taken from https://sebastiancallh.github.io/post/langevin/
        using Flux
        using Flux: gpu
        using MLDataUtils: shuffleobs, stratifiedobs, rescale!
        using RDatasets, Statistics
        using Plots, Random
        Random.seed!(0)

        data = dataset("ISLR", "Default")
        todigit(x) = x == "Yes" ? 1.0 : 0.0
        data[!, :Default] = map(todigit, data[:, :Default])
        data[!, :Student] = map(todigit, data[:, :Student])

        target = :Default
        numerics = [:Balance, :Income]
        features = [:Student, :Balance, :Income]
        train, test = shuffleobs(data) |> d -> stratifiedobs(first, d, p = 0.7)

        for feature in numerics
            μ, σ = rescale!(train[!, feature], obsdim = 1)
            rescale!(test[!, feature], μ, σ, obsdim = 1)
        end

        prep_X(x) = Matrix(x)' |> gpu
        prep_y(y) = reshape(y, 1, :) |> gpu
        train_X, test_X = prep_X.((train[:, features], test[:, features]))
        train_y, test_y = prep_y.((train[:, target], test[:, target]))
        train_set = Flux.DataLoader(
            (train_X, train_y),
            batchsize = size(train_X, 2),
            shuffle = false,
        )

        function train_logreg(; steps::Int = 1000, opt = Flux.Descent(2))
            Random.seed!(1)

            paramvec(θ) = reduce(hcat, cpu(θ))
            model = Dense(length(features), 1, sigmoid) |> gpu
            θ = Flux.params(model)
            θ₀ = paramvec(θ)

            predict(x; thres = 0.5) = model(x) .> thres
            accuracy(x, y) = mean(cpu(predict(x)) .== cpu(y))

            loss(yhat, y) = Flux.binarycrossentropy(yhat, y)
            avg_loss(yhat, y) = mean(loss(yhat, y))
            trainloss() = avg_loss(model(train_X), train_y)
            testloss() = avg_loss(model(test_X), test_y)

            trainlosses = [cpu(trainloss()); zeros(steps)]
            testlosses = [cpu(testloss()); zeros(steps)]
            weights = [cpu(θ₀); zeros(steps, length(θ₀))]

            opt_state = Flux.setup(opt, model)

            for t = 1:steps

                for data in train_set

                    input, label = data

                    # Calculate the gradient of the objective
                    # with respect to the parameters within the model:
                    grads = Flux.gradient(model) do m
                        result = m(input)
                        loss(result, label)
                    end

                    Flux.update!(opt_state, model, grads[1])
                end

                # Bookkeeping
                weights[t+1, :] = cpu(paramvec(θ))
                trainlosses[t+1] = cpu(trainloss())
                testlosses[t+1] = cpu(testloss())
            end

            println("Final parameters are $(paramvec(θ))")
            println("Test accuracy is $(accuracy(test_X, test_y))")

            model, weights, trainlosses, testlosses
        end

        results =
            train_logreg(steps = 10000, opt = SGLD(10.0, 1000.0, 0.9))
        model, weights, trainlosses, testlosses = results
        plot(weights; label = ["Student" "Balance" "Income" "Intercept"])

        results =
            train_logreg(steps = 1000, opt = ImproperSGLD(2.0, 0.01))
        model, weights, trainlosses, testlosses = results
        plot(weights; label = ["Student" "Balance" "Income" "Intercept"])

        @test true

    end

end
