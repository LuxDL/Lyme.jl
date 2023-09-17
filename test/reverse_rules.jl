include("test_utils.jl")

@testset "$mode: Dense" for (mode, aType, dev, ongpu) in MODES
    model = Dense(10 => 5, tanh)
    rng = get_stable_rng()
    x = rand(rng, 10, 2) |> aType
    ps, st = Lux.setup(rng, model) |> dev

    loss_function(model, x, ps, st) = sum(abs2, first(model(x, ps, st)))

    ∂x = zero(x)
    ∂ps = fmap(zero, ps)

    Enzyme.autodiff(Reverse, loss_function, Const(model), Duplicated(x, ∂x),
        Duplicated(ps, ∂ps), Const(st))

    (_, ∂xₜ, ∂psₜ, _) = Zygote.gradient(loss_function, model, x, ps, st)

    @test check_approx(∂x, ∂xₜ)
    @test check_approx(∂ps, ∂psₜ)
end
