get_inference_cache(interp::CustomInterpreter) = CustomLocalCache(interp, interp.native.cache)

struct CustomLocalCache
    interp::CustomInterpreter
    native::Vector{InferenceResult}
end

# here we can work on local cache retrieval
function CC.cache_lookup(linfo::MethodInstance, given_argtypes::Vector{Any}, inf_cache::CustomLocalCache)
    ret = cache_lookup(linfo, given_argtypes, inf_cache.native)

    # return nothing # to invalidate local cache (for constant analysis)

    return ret
end

function CC.push!(inf_cache::CustomLocalCache, inf_result::InferenceResult)
    return CC.push!(inf_cache.native, inf_result)
end
