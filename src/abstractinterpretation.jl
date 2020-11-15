function abstract_call_gf_by_type(interp::DummyInterpreter, @nospecialize(f), argtypes::Vector{Any}, @nospecialize(atype), sv::InferenceState,
                                  max_methods::Int = InferenceParams(interp).MAX_METHODS)
    ret = @invoke abstract_call_gf_by_type(interp::AbstractInterpreter, f, argtypes::Vector{Any}, atype, sv::InferenceState,
                                           max_methods::Int)

    return ret
end

function abstract_call_method_with_const_args(interp::DummyInterpreter, @nospecialize(rettype), @nospecialize(f), argtypes::Vector{Any}, match::MethodMatch, sv::InferenceState, edgecycle::Bool)
    ret = @invoke abstract_call_method_with_const_args(interp::AbstractInterpreter, rettype, f, argtypes::Vector{Any}, match::MethodMatch, sv::InferenceState, edgecycle::Bool)

    return ret
end

function abstract_call_method(interp::DummyInterpreter, method::Method, @nospecialize(sig), sparams::SimpleVector, hardlimit::Bool, sv::InferenceState)
    ret = @invoke abstract_call_method(interp::AbstractInterpreter, method::Method, sig, sparams::SimpleVector, hardlimit::Bool, sv::InferenceState)

    return ret
end

function precise_container_type(interp::DummyInterpreter, @nospecialize(itft), @nospecialize(typ), sv::InferenceState)
    ret = @invoke precise_container_type(interp::AbstractInterpreter, itft, typ, sv::InferenceState)

    return ret
end

function abstract_iteration(interp::DummyInterpreter, @nospecialize(itft), @nospecialize(itertype), sv::InferenceState)
    ret = @invoke abstract_iteration(interp::AbstractInterpreter, itft, itertype, sv::InferenceState)

    return ret
end

function abstract_apply(interp::DummyInterpreter, @nospecialize(itft), @nospecialize(aft),    aargtypes::Vector{Any}, sv::InferenceState,
                        max_methods::Int = InferenceParams(interp).MAX_METHODS)
    ret = @invoke abstract_apply(interp::AbstractInterpreter, itft, aft, aargtypes::Vector{Any}, sv::InferenceState,
                                 max_methods::Int)

    return ret
end

function abstract_call_builtin(interp::DummyInterpreter, f::Builtin, fargs::Union{Nothing,Vector{Any}},
                               argtypes::Vector{Any}, sv::InferenceState, max_methods::Int)
    ret = @invoke abstract_call_builtin(interp::AbstractInterpreter, f::Builtin, fargs::Union{Nothing,Vector{Any}},
                                        argtypes::Vector{Any}, sv::InferenceState, max_methods::Int)

    return ret
end

function abstract_call_known(interp::DummyInterpreter, @nospecialize(f),
                             fargs::Union{Nothing,Vector{Any}}, argtypes::Vector{Any},
                             sv::InferenceState,
                             max_methods::Int = InferenceParams(interp).MAX_METHODS)
    ret = @invoke abstract_call_known(interp::AbstractInterpreter, f,
                                      fargs::Union{Nothing,Vector{Any}}, argtypes::Vector{Any},
                                      sv::InferenceState,
                                      max_methods::Int)
end

function abstract_call(interp::DummyInterpreter, fargs::Union{Nothing,Vector{Any}}, argtypes::Vector{Any},
                       sv::InferenceState, max_methods::Int = InferenceParams(interp).MAX_METHODS)
    ret = @invoke abstract_call(interp::AbstractInterpreter, fargs::Union{Nothing,Vector{Any}}, argtypes::Vector{Any},
                                sv::InferenceState, max_methods::Int)

    return ret
end

function abstract_eval_cfunction(interp::DummyInterpreter, e::Expr, vtypes::VarTable, sv::InferenceState)
    ret = @invoke abstract_eval_cfunction(interp::AbstractInterpreter, e::Expr, vtypes::VarTable, sv::InferenceState)

    return ret
end

function abstract_eval_value_expr(interp::DummyInterpreter, e::Expr, vtypes::VarTable, sv::InferenceState)
    ret = @invoke abstract_eval_value_expr(interp::AbstractInterpreter, e::Expr, vtypes::VarTable, sv::InferenceState)

    return ret
end

function abstract_eval_special_value(interp::DummyInterpreter, @nospecialize(e), vtypes::VarTable, sv::InferenceState)
    ret = @invoke abstract_eval_special_value(interp::AbstractInterpreter, e, vtypes::VarTable, sv::InferenceState)

    return ret
end

function abstract_eval_value(interp::DummyInterpreter, @nospecialize(e), vtypes::VarTable, sv::InferenceState)
    ret = @invoke abstract_eval_value(interp::AbstractInterpreter, e, vtypes::VarTable, sv::InferenceState)

    return ret
end

function abstract_eval_statement(interp::DummyInterpreter, @nospecialize(e), vtypes::VarTable, sv::InferenceState)
    ret = @invoke abstract_eval_statement(interp::AbstractInterpreter, e, vtypes::VarTable, sv::InferenceState)

    return ret
end

function typeinf_local(interp::DummyInterpreter, frame::InferenceState)
    ret = @invoke typeinf_local(interp::AbstractInterpreter, frame::InferenceState)

    return ret
end

function typeinf_nocycle(interp::DummyInterpreter, frame::InferenceState)
    ret = @invoke typeinf_nocycle(interp::AbstractInterpreter, frame::InferenceState)

    return ret
end
