using ForwardDiff,
    Functors, LuxAMDGPU, LuxCUDA, LuxTestUtils, Lyme, Random, StableRNGs, Test, Zygote
import LuxTestUtils: check_approx

CUDA.allowscalar(false)

const GROUP = get(ENV, "GROUP", "All")

cpu_testing() = GROUP == "All" || GROUP == "CPU"
cuda_testing() = (GROUP == "All" || GROUP == "CUDA") && LuxCUDA.functional()
amdgpu_testing() = (GROUP == "All" || GROUP == "AMDGPU") && LuxAMDGPU.functional()

const MODES = begin
    # Mode, Array Type, Device Function, GPU?
    modes = []
    cpu_testing() && push!(modes, ("CPU", Array, LuxCPUDevice(), false))
    cuda_testing() && push!(modes, ("CUDA", CuArray, LuxCUDADevice(), true))
    amdgpu_testing() && push!(modes, ("AMDGPU", ROCArray, LuxAMDGPUDevice(), true))

    modes
end

get_stable_rng(seed=12345) = StableRNG(seed)
