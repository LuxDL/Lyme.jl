# `mul!`
function augmented_primal(config::ConfigWidth{1}, f::Const{typeof(mul!)}, ::Type{<:Const}, 
    C::Union{Const, Duplicated}, A::Union{Const, Duplicated}, B::Union{Const, Duplicated})
    @warn "Using Custom Reverse Rule for `mul!`" maxlog=1
    mul!(C.val, A.val, B.val)
    primal = needs_primal(config) ? C.val : nothing
    Atape = overwritten(config)[3] ? copy(A.val) : nothing
    Btape = overwritten(config)[4] ? copy(B.val) : nothing
    return AugmentedReturn(primal, nothing, (Atape, Btape))
end

function reverse(config::ConfigWidth{1}, f::Const{typeof(mul!)}, ::Type{<:Const}, tape,
    C::Union{Const, Duplicated}, A::Union{Const, Duplicated}, B::Union{Const, Duplicated})
    C isa Const && return ntuple(_ -> nothing, 3)

    Aval = overwritten(config)[3] ? first(tape) : A.val
    Bval = overwritten(config)[4] ? last(tape) : B.val

    !(B isa Const) && mul!(B.dval, Aval', C.dval, true, true)
    !(A isa Const) && mul!(A.dval, C.dval, Bval', true, true)

    return ntuple(_ -> nothing, 3)
end