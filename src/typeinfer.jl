function typeinf(interp::CustomInterpreter, frame::InferenceState)
    interp.depth[] += 1
    ret = @invoke typeinf(interp::AbstractInterpreter, frame::InferenceState)
    interp.depth[] -= 1

    return ret
end

function _typeinf(interp::CustomInterpreter, frame::InferenceState)
    ret = @invoke _typeinf(interp::AbstractInterpreter, frame::InferenceState)

    return ret
end

function transform_result_for_cache(interp::CustomInterpreter, linfo::MethodInstance,
                                    @nospecialize(inferred_result))
    ret = @invoke transform_result_for_cache(interp::AbstractInterpreter, linfo::MethodInstance,
                                             inferred_result)

    return ret
end

function cache_result!(interp::CustomInterpreter, result::InferenceResult, valid_worlds::WorldRange)
    ret = @invoke cache_result!(interp::AbstractInterpreter, result::InferenceResult, valid_worlds::WorldRange)

    return ret
end

function finish(me::InferenceState, interp::CustomInterpreter)
    ret = @invoke finish(me::InferenceState, interp::AbstractInterpreter)

    return ret
end

function finish(src::CodeInfo, interp::CustomInterpreter)
    ret = @invoke finish(me::CodeInfo, interp::AbstractInterpreter)

    return ret
end

function is_same_frame(interp::CustomInterpreter, linfo::MethodInstance, frame::InferenceState)
    ret = @invoke is_same_frame(interp::AbstractInterpreter, linfo::MethodInstance, frame::InferenceState)

    return ret
end

function resolve_call_cycle!(interp::CustomInterpreter, linfo::MethodInstance, parent::InferenceState)
    ret = @invoke resolve_call_cycle!(interp::AbstractInterpreter, linfo::MethodInstance, parent::InferenceState)

    return ret
end

function typeinf_edge(interp::CustomInterpreter, method::Method, @nospecialize(atypes), sparams::SimpleVector, caller::InferenceState)
    ret = @invoke typeinf_edge(interp::AbstractInterpreter, method::Method, atypes, sparams::SimpleVector, caller::InferenceState)

    return ret
end
