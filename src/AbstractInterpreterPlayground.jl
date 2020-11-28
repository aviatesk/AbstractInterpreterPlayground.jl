module AbstractInterpreterPlayground

# overloads
# ---------

import Core.Compiler:
    # abstractinterpreterinterface.jl
    InferenceParams,
    OptimizationParams,
    get_world_counter,
    get_inference_cache,
    lock_mi_inference,
    unlock_mi_inference,
    add_remark!,
    may_optimize,
    may_compress,
    may_discard_trees,
    # cicache.jl
    code_cache,
    WorldView,
    # tfuncs.jl
    invoke_tfunc,
    builtin_tfunction,
    return_type_tfunc,
    # abstractinterpretation.jl
    abstract_call_gf_by_type,
    abstract_call_method_with_const_args,
    abstract_call_method,
    precise_container_type,
    abstract_iteration,
    abstract_apply,
    abstract_call_builtin,
    abstract_call_known,
    abstract_call,
    abstract_eval_cfunction,
    abstract_eval_value_expr,
    abstract_eval_special_value,
    abstract_eval_value,
    abstract_eval_statement,
    typeinf_local,
    typeinf_nocycle,
    # typeinfer.jl
    typeinf,
    _typeinf,
    transform_result_for_cache,
    is_same_frame,
    typeinf_edge

# imports
# -------

import Core:
    MethodMatch,
    LineInfoNode,
    SimpleVector,
    Builtin,
    Typeof,
    svec

import Core.Compiler:
    AbstractInterpreter,
    NativeInterpreter,
    InferenceState,
    InferenceResult,
    MethodInstance,
    WorldRange,
    CodeInfo,
    VarTable,
    CodeInstance,
    to_tuple_type,
    _methods_by_ftype,
    specialize_method

import Base:
    unwrap_unionall,
    rewrap_unionall

import Base.Meta:
    isexpr,
    lower

using InteractiveUtils

const CC = Core.Compiler

# utilties
# --------

"""
    @invoke f(arg::T, ...; kwargs...)

Provides a convenient way to call [`invoke`](@ref);
`@invoke f(arg1::T1, arg2::T2; kwargs...)` will be expanded into `invoke(f, Tuple{T1,T2}, arg1, arg2; kwargs...)`.
When an argument's type annotation is omitted, it's specified as `Any` argument, e.g.
`@invoke f(arg1::T, arg2)` will be expanded into `invoke(f, Tuple{T,Any}, arg1, arg2)`.

This could be used to call down to `NativeInterpreter`'s abstract interpretation method of
  `f` while passing `CustomInterpreter` so that subsequent calls of abstract interpretation
  functions overloaded against `CustomInterpreter` can be called from the native method of `f`;
e.g. calls down to `NativeInterpreter`'s `abstract_call_gf_by_type` method:
```julia
@invoke abstract_call_gf_by_type(interp::AbstractInterpreter, f, argtypes::Vector{Any}, atype, sv::InferenceState,
                                 max_methods::Int)
```
"""
macro invoke(ex)
    f, args, kwargs = destructure_callex(ex)
    arg2typs = map(args) do x
        isexpr(x, :(::)) ? (x.args...,) : (x, GlobalRef(Core, :Any))
    end
    args, argtypes = first.(arg2typs), last.(arg2typs)
    return if isempty(kwargs)
        :($(GlobalRef(Core, :invoke))($(f), Tuple{$(argtypes...)}, $(args...))) # might not be necessary
    else
        :($(GlobalRef(Core, :invoke))($(f), Tuple{$(argtypes...)}, $(args...); $(kwargs...)))
    end |> esc
end

function destructure_callex(ex)
    @assert isexpr(ex, :call) "call expression f(args...; kwargs...) should be given"

    f = first(ex.args)
    args = []
    kwargs = []
    for x in ex.args[2:end]
        if isexpr(x, :parameters)
            append!(kwargs, x.args)
        elseif isexpr(x, :kw)
            push!(kwargs, x)
        else
            push!(args, x)
        end
    end

    return f, args, kwargs
end

# for inspection
macro lwr(ex) QuoteNode(lower(__module__, ex)) end
macro src(ex) QuoteNode(first(lower(__module__, ex).args)) end

# includes
# --------

include("abstractinterpreterinterface.jl")
include("cicache.jl")
include("tfuncs.jl")
include("abstractinterpretation.jl")
include("typeinfer.jl")
include("print.jl")

# entry
# -----

macro enter_call(ex0...)
    return InteractiveUtils.gen_call_with_extracted_types_and_kwargs(@__MODULE__, :enter_call, ex0)
end

function enter_call(@nospecialize(f), @nospecialize(types=Tuple{});
                    kwargs...)
    interp = CustomInterpreter(; inf_params = gen_inf_params(; kwargs...),
                                 opt_params = gen_opt_params(; kwargs...),
                                 kwargs...)
    ft = Typeof(f)
    tt = if isa(types, Type)
        u = unwrap_unionall(types)
        rewrap_unionall(Tuple{ft, u.parameters...}, types)
    else
        Tuple{ft, types...}
    end
    return enter_gf_by_type!(interp, tt)
end

# TODO `enter_call_builtin!` ?
function enter_gf_by_type!(interp::CustomInterpreter,
                           @nospecialize(tt::Type{<:Tuple}),
                           world::UInt = get_world_counter(interp),
                           )
    mms = _methods_by_ftype(tt, InferenceParams(interp).MAX_METHODS, world)
    @assert mms !== false "unable to find matching method for $(tt)"

    filter!(mm->mm.spec_types===tt, mms)
    @assert length(mms) == 1 "unable to find single target method for $(tt)"

    mm = first(mms)::MethodMatch

    return enter_method_signature!(interp, mm.method, mm.spec_types, mm.sparams)
end

function enter_method_signature!(interp::CustomInterpreter,
                                 m::Method,
                                 @nospecialize(atype),
                                 sparams::SimpleVector,
                                 world::UInt = get_world_counter(interp),
                                 )
    mi = specialize_method(m, atype, sparams)

    result = InferenceResult(mi)

    frame = InferenceState(result, #= cached =# true, interp)

    typeinf(interp, frame)

    return interp, frame
end

function enter_method!(interp::CustomInterpreter,
                       m::Method,
                       world::UInt = get_world_counter(interp),
                       )
    return enter_method_signature!(interp, m, m.sig, sparams_from_method_signature(m), world)
end

function sparams_from_method_signature(m)
    s = TypeVar[]
    sig = m.sig
    while isa(sig, UnionAll)
        push!(s, sig.var)
        sig = sig.body
    end
    return svec(s...)
end

# exports

export
    @enter_call,
    enter_call

end
