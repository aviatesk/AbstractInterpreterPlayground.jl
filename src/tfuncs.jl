function invoke_tfunc(interp::DummyInterpreter, @nospecialize(ft), @nospecialize(types), @nospecialize(argtype), sv::InferenceState)
    ret = @invoke invoke_tfunc(interp::AbstractInterpreter, ft, types, argtype, sv::InferenceState)
end

function builtin_tfunction(interp::DummyInterpreter, @nospecialize(f), argtypes::Array{Any,1},
                           sv::Union{InferenceState,Nothing})
    ret = @invoke builtin_tfunction(interp::AbstractInterpreter, f, argtypes::Array{Any,1},
                                    sv::Union{InferenceState,Nothing})
end

function return_type_tfunc(interp::DummyInterpreter, argtypes::Vector{Any}, sv::InferenceState)
    ret = @invoke return_type_tfunc(interp::AbstractInterpreter, argtypes::Vector{Any}, sv::InferenceState)
end
