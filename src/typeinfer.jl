function typeinf(interp::DummyInterpreter, frame::InferenceState)
    interp.depth[] += 1
    ret = @invoke typeinf(interp::AbstractInterpreter, frame::InferenceState)
    interp.depth[] -= 1

    return ret
end

function _typeinf(interp::DummyInterpreter, frame::InferenceState)
    ret = @invoke _typeinf(interp::AbstractInterpreter, frame::InferenceState)

    return ret
end

function transform_result_for_cache(interp::DummyInterpreter, linfo::MethodInstance,
                                    @nospecialize(inferred_result))
    ret = @invoke transform_result_for_cache(interp::AbstractInterpreter, linfo::MethodInstance,
                                             inferred_result)

    return ret
end

function cache_result!(interp::DummyInterpreter, result::InferenceResult, valid_worlds::WorldRange)
    ret = @invoke cache_result!(interp::AbstractInterpreter, result::InferenceResult, valid_worlds::WorldRange)

    return ret
end

function finish(me::InferenceState, interp::DummyInterpreter)
    ret = @invoke finish(me::InferenceState, interp::AbstractInterpreter)

    return ret
end

function finish(src::CodeInfo, interp::DummyInterpreter)
    ret = @invoke finish(me::CodeInfo, interp::AbstractInterpreter)

    return ret
end

function is_same_frame(interp::DummyInterpreter, linfo::MethodInstance, frame::InferenceState)
    ret = @invoke is_same_frame(interp::AbstractInterpreter, linfo::MethodInstance, frame::InferenceState)

    return ret
end

function resolve_call_cycle!(interp::DummyInterpreter, linfo::MethodInstance, parent::InferenceState)
    ret = @invoke resolve_call_cycle!(interp::AbstractInterpreter, linfo::MethodInstance, parent::InferenceState)

    return ret
end

function typeinf_edge(interp::DummyInterpreter, method::Method, @nospecialize(atypes), sparams::SimpleVector, caller::InferenceState)
    ret = @invoke typeinf_edge(interp::AbstractInterpreter, method::Method, atypes, sparams::SimpleVector, caller::InferenceState)

    return ret
end
