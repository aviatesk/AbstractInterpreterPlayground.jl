function typeinf(interp::DummyInterpreter, frame::InferenceState)
    ret = @invoke typeinf(interp::AbstractInterpreter, frame::InferenceState)
end

function _typeinf(interp::DummyInterpreter, frame::InferenceState)
    ret = @invoke _typeinf(interp::AbstractInterpreter, frame::InferenceState)
end

function transform_result_for_cache(interp::DummyInterpreter, linfo::MethodInstance,
                                    @nospecialize(inferred_result))
    ret = @invoke transform_result_for_cache(interp::AbstractInterpreter, linfo::MethodInstance,
                                             inferred_result)
end

function cache_result!(interp::DummyInterpreter, result::InferenceResult, valid_worlds::WorldRange)
    ret = @invoke cache_result!(interp::AbstractInterpreter, result::InferenceResult, valid_worlds::WorldRange)
end

function finish(me::InferenceState, interp::DummyInterpreter)
    ret = @invoke finish(me::InferenceState, interp::AbstractInterpreter)
end

function finish(src::CodeInfo, interp::DummyInterpreter)
    ret = @invoke finish(me::CodeInfo, interp::AbstractInterpreter)
end

function is_same_frame(interp::DummyInterpreter, linfo::MethodInstance, frame::InferenceState)
    ret = @invoke is_same_frame(interp::AbstractInterpreter, linfo::MethodInstance, frame::InferenceState)
end

function resolve_call_cycle!(interp::DummyInterpreter, linfo::MethodInstance, parent::InferenceState)
    ret = @invoke resolve_call_cycle!(interp::AbstractInterpreter, linfo::MethodInstance, parent::InferenceState)
end

function typeinf_edge(interp::DummyInterpreter, method::Method, @nospecialize(atypes), sparams::SimpleVector, caller::InferenceState)
    ret = @invoke typeinf_edge(interp::AbstractInterpreter, method::Method, atypes, sparams::SimpleVector, caller::InferenceState)
end
