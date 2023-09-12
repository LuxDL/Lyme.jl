# `mul!`
function forward(func::Const{typeof(mul!)},
    RT::Type{<:Union{Const, DuplicatedNoNeed, Duplicated}},
    C::Union{Const, Duplicated}, A::Union{Const, Duplicated}, B::Union{Const, Duplicated})
    mul!(C.val, A.val, B.val)

    !(A isa Const) && mul!(C.dval, A.dval, B.val)

    !(B isa Const) && mul!(C.dval, A.val, B.dval, A isa Const, A isa Const)

    RT <: Const && return C.val
    RT <: DuplicatedNoNeed && return C.dval
    return C
end

function forward(func::Const{typeof(mul!)},
    RT::Type{<:Union{Const, DuplicatedNoNeed, Duplicated}},
    C::Union{Const, Duplicated}, A::Union{Const, Duplicated}, B::Union{Const, Duplicated},
    α::Union{Const, Duplicated}, β::Union{Const, Duplicated})

    all_bool = α.val isa Bool && β.val isa Bool

    if all_bool
        mul!(C.val, A.val, B.val, α.val, β.val)
    else
        AB = A.val * B.val
        C.dval .= (!(C isa Const) ? (C.dval .* β.val) : false) .+
                  (!(β isa Const) ? (C.val .* β.dval) : false) .+
                  (!(α isa Const) ? (AB .* α.dval) : false)
    end

    !(A isa Const) && mul!(C.dval, A.dval, B.val, α.val, all_bool ? β.val : true)

    !(B isa Const) && mul!(C.dval, A.val, B.dval, α.val, !(A isa Const) ? true : β.val)

    all_bool && axpby!(α.cal, AB, β.val, C.val)

    RT <: Const && return C.val
    RT <: DuplicatedNoNeed && return C.dval
    return C
end
