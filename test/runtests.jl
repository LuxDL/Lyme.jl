using Aqua, Lyme, SafeTestset, Test

@testset "Lyme.jl" begin
    @safetestset "Forward Rules" begin
        include("forward_rules.jl")
    end

    @safetestset "Reverse Rules" begin
        include("reverse_rules.jl")
    end

    if VERSION ≥ v"1.9"
        @testset "Code quality (Aqua.jl)" begin
            # We pirate Lux and LuxCore in this package
            Aqua.test_all(Lyme; ambiguities=false, piracy=false)
        end
    end
end
