struct DummyInterpreter <: AbstractInterpreter
    #= native =#

    native::NativeInterpreter
    optimize::Bool
    compress::Bool
    discard_trees::Bool

    #= debugging =#
    depth::Ref{Int}

    function DummyInterpreter(world             = get_world_counter();
                              inf_params        = gen_inf_params(),
                              opt_params        = gen_opt_params(),
                              optimize          = true,
                              compress          = false,
                              discard_trees     = false,
                              # dummy kwargs so that kwargs for other functions can be passed on
                              __kwargs...)
        native = NativeInterpreter(world; inf_params, opt_params)
        return new(native,
                   optimize,
                   compress,
                   discard_trees,
                   Ref(0),
                   )
    end
end

function gen_inf_params(; # more constant prop, more correct reports ?
                          aggressive_constant_propagation::Bool = true,
                          # turn this off to get profiles on `throw` blocks, this might be good to default
                          # to `true` since `throw` calls themselves will be reported anyway
                          unoptimize_throw_blocks::Bool = true,
                          # dummy kwargs so that kwargs for other functions can be passed on
                          __kwargs...)
    return @static VERSION ≥ v"1.6.0-DEV.837" ?
           InferenceParams(; aggressive_constant_propagation,
                             unoptimize_throw_blocks,
                             ) :
           InferenceParams(; aggressive_constant_propagation,
                             )
end

function gen_opt_params(; # inlining should be disabled for `DummyInterpreter`, otherwise virtual stack frame
                          # traversing will fail for frames after optimizer runs on
                          inlining = false,
                          # dummy kwargs so that kwargs for other functions can be passed on
                          __kwargs...)
    return OptimizationParams(; inlining,
                                )
end

# API
# ---

InferenceParams(interp::DummyInterpreter) = InferenceParams(interp.native)
OptimizationParams(interp::DummyInterpreter) = OptimizationParams(interp.native)
get_world_counter(interp::DummyInterpreter) = get_world_counter(interp.native)
get_inference_cache(interp::DummyInterpreter) = get_inference_cache(interp.native)

lock_mi_inference(::DummyInterpreter, ::MethodInstance) = nothing
unlock_mi_inference(::DummyInterpreter, ::MethodInstance) = nothing

function add_remark!(interp::DummyInterpreter, sv, s)
    ret = add_remark!(interp.native, sv, s)
end

may_optimize(interp::DummyInterpreter) = interp.optimize
may_compress(interp::DummyInterpreter) = interp.compress
may_discard_trees(interp::DummyInterpreter) = interp.discard_trees
