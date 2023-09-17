module Lyme

import Reexport: @reexport

@reexport using Enzyme, Lux

import .EnzymeRules: forward, reverse, augmented_primal
using .EnzymeRules

using LinearAlgebra, LuxCore, LuxLib, NNlib, Random
using LuxAMDGPU, LuxCUDA

EnzymeRules.inactive(::typeof(CUDA.cuOccupancyMaxPotentialBlockSize), args...) = nothing

include("forward_rules.jl")
include("reverse_rules.jl")

end
