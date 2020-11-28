function invoke_tfunc(interp::CustomInterpreter, @nospecialize(ft), @nospecialize(types), @nospecialize(argtype), sv::InferenceState)
    ret = @invoke invoke_tfunc(interp::AbstractInterpreter, ft, types, argtype, sv::InferenceState)

    return ret
end

function builtin_tfunction(interp::CustomInterpreter, @nospecialize(f), argtypes::Array{Any,1},
                           sv::Union{InferenceState,Nothing})
    ret = @invoke builtin_tfunction(interp::AbstractInterpreter, f, argtypes::Array{Any,1},
                                    sv::Union{InferenceState,Nothing})

    return ret
end

function return_type_tfunc(interp::CustomInterpreter, argtypes::Vector{Any}, sv::InferenceState)
    ret = @invoke return_type_tfunc(interp::AbstractInterpreter, argtypes::Vector{Any}, sv::InferenceState)

    return ret
end
