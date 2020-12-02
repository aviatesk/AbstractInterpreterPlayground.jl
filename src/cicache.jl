code_cache(interp::CustomInterpreter) = CustomGlobalCache(interp, code_cache(interp.native))

struct CustomGlobalCache{NativeCache}
    interp::CustomInterpreter
    native::NativeCache
    CustomGlobalCache(interp::CustomInterpreter, native::NativeCache) where {NativeCache} =
        new{NativeCache}(interp, native)
end
WorldView(tpc::CustomGlobalCache, wr::WorldRange) = CustomGlobalCache(tpc.interp, WorldView(tpc.native, wr))
WorldView(tpc::CustomGlobalCache, args...) = WorldView(tpc, WorldRange(args...))

CC.haskey(tpc::CustomGlobalCache, mi::MethodInstance) = CC.haskey(tpc.native, mi)

# here we can work on global cache retrieval
function CC.get(tpc::CustomGlobalCache, mi::MethodInstance, default)
    ret = CC.get(tpc.native, mi, default)

    # return default # NOTE: return `default` will invalidate inference cache

    return ret
end

CC.getindex(tpc::CustomGlobalCache, mi::MethodInstance) = CC.getindex(tpc.native, mi)

CC.setindex!(tpc::CustomGlobalCache, ci::CodeInstance, mi::MethodInstance) = CC.setindex!(tpc.native, ci, mi)
