code_cache(interp::DummyInterpreter) = DummyCache(interp, code_cache(interp.native))

struct DummyCache{NativeCache}
    interp::DummyInterpreter
    native::NativeCache
    DummyCache(interp::DummyInterpreter, native::NativeCache) where {NativeCache} =
        new{NativeCache}(interp, native)
end
WorldView(tpc::DummyCache, wr::WorldRange) = DummyCache(tpc.interp, WorldView(tpc.native, wr))
WorldView(tpc::DummyCache, args...) = WorldView(tpc, WorldRange(args...))

CC.haskey(tpc::DummyCache, mi::MethodInstance) = CC.haskey(tpc.native, mi)

function CC.get(tpc::DummyCache, mi::MethodInstance, default)
    ret = CC.get(tpc.native, mi, default)

    # return default # NOTE: return default to invalidate inference cache

    return ret
end

CC.getindex(tpc::DummyCache, mi::MethodInstance) = CC.getindex(tpc.native, mi)

CC.setindex!(tpc::DummyCache, ci::CodeInstance, mi::MethodInstance) = CC.setindex!(tpc.native, ci, mi)
