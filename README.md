## AbstractInterpreterPlayground.jl

![CI](https://github.com/aviatesk/AbstractInterpreterPlayground.jl/workflows/CI/badge.svg)
[![codecov](https://codecov.io/gh/aviatesk/AbstractInterpreterPlayground.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/aviatesk/AbstractInterpreterPlayground.jl)

This package provides a scaffold to debug Julia's type inference system;
The abstract interpretation methods within `Core.Compiler` module are overloaded against `AbstractInterpreterPlayground.DummyInterpreter <: Core.Compiler.AbstractInterpreter` so that we can easily inject custom user-code into an abstract interpretation pass, e.g. print debug.
Note that the overloaded methods pass on `DummyInterpreter` to the original (i.e. `NativeInterpreter`'s) methods, so that the subsequent callee abstract interpretation calls within them will be recursively called against `DummyInterpreter`.


### Installation

```julia
pkg> dev https://github.com/aviatesk/AbstractInterpreterPlayground.jl
```

### Example

Let's apply the following diff and then `typeinf(interp::DummyInterpreter, frame::InferenceState)` will nicely print out the result of each local type inferences frame:

> git apply example.diff

```diff
diff --git a/src/typeinfer.jl b/src/typeinfer.jl
index 40318af..67d9cd9 100644
--- a/src/typeinfer.jl
+++ b/src/typeinfer.jl
@@ -1,8 +1,21 @@
 function typeinf(interp::DummyInterpreter, frame::InferenceState)
+    # debug info before typeinf
+    depth = interp.depth[]
+    io = stdout::IO
+    color = RAIL_COLORS[(depth+1)%N_RAILS+1]
+    print_rails(io, depth)
+    printstyled(io, "┌ @ "; color)
+    println(io, frame.linfo)
+
     interp.depth[] += 1
     ret = @invoke typeinf(interp::AbstractInterpreter, frame::InferenceState)
     interp.depth[] -= 1
 
+    # debug info after typeinf
+    print_rails(io, depth)
+    printstyled(io, "└─> "; color)
+    printlnstyled(io, frame.src.rettype; color = TYPE_ANNOTATION_COLOR)
+
     return ret
 end
```

```julia
julia> using AbstractInterpreterPlayground

julia> @enter_call sin(1);
┌ @ MethodInstance for sin(::Int64)
│┌ @ MethodInstance for sin(::Float64)
││┌ @ MethodInstance for /(::Float64, ::Int64)
│││┌ @ MethodInstance for promote(::Float64, ::Int64)
││││┌ @ MethodInstance for _promote(::Float64, ::Int64)
│││││┌ @ MethodInstance for convert(::Type{Float64}, ::Float64)
│││││└─> Float64
│││││┌ @ MethodInstance for convert(::Type{Float64}, ::Int64)
││││││┌ @ MethodInstance for Float64(::Int64)
││││││└─> Float64
│││││└─> Float64
││││└─> Tuple{Float64, Float64}
││││┌ @ MethodInstance for indexed_iterate(::Tuple{Float64, Float64}, ::Int64)
│││││┌ @ MethodInstance for indexed_iterate(::Tuple{Float64, Float64}, ::Int64, ::Int64)
││││││┌ @ MethodInstance for +(::Int64, ::Int64)
││││││└─> Int64
│││││└─> Tuple{Float64, Int64}
││││└─> Tuple{Float64, Int64}
││││┌ @ MethodInstance for indexed_iterate(::Tuple{Float64, Float64}, ::Int64, ::Int64)
│││││┌ @ MethodInstance for +(::Int64, ::Int64)
│││││└─> Int64
││││└─> Tuple{Float64, Int64}
│││└─> Tuple{Float64, Float64}
│││┌ @ MethodInstance for /(::Float64, ::Float64)
│││└─> Float64
││└─> Float64
││┌ @ MethodInstance for sqrt(::Float64)
││└─> Float64
││┌ @ MethodInstance for sqrt(::Float64)
│││┌ @ MethodInstance for <(::Float64, ::Float64)
│││└─> Bool
││└─> Float64
││┌ @ MethodInstance for sin_kernel(::Float64)
│││┌ @ MethodInstance for evalpoly(::Float64, ::Tuple{Float64, Float64, Float64})
││││┌ @ MethodInstance for lastindex(::Tuple{Float64, Float64, Float64})
││││└─> Int64
││││┌ @ MethodInstance for getindex(::Tuple{Float64, Float64, Float64}, ::Int64)
││││└─> Float64
││││┌ @ MethodInstance for getindex(::Tuple{Float64, Float64, Float64}, ::Int64)
││││└─> Float64
││││┌ @ MethodInstance for getindex(::Tuple{Float64, Float64, Float64}, ::Int64)
││││└─> Float64
│││└─> Float64
││└─> Float64
││┌ @ MethodInstance for Float64(::Float64)
││└─> Float64
││┌ @ MethodInstance for isinf(::Float64)
││└─> Bool
││┌ @ MethodInstance for sin_domain_error(::Float64)
││└─> Union{}
││┌ @ MethodInstance for rem_pio2_kernel(::Float64)
│││┌ @ MethodInstance for poshighword(::Float64)
││││┌ @ MethodInstance for poshighword(::UInt64)
│││││┌ @ MethodInstance for highword(::UInt64)
││││││┌ @ MethodInstance for >>>(::UInt64, ::Int64)
│││││││┌ @ MethodInstance for <=(::Int64, ::Int64)
│││││││└─> Bool
│││││││┌ @ MethodInstance for unsigned(::Int64)
││││││││┌ @ MethodInstance for reinterpret(::Type{UInt64}, ::Int64)
││││││││└─> UInt64
│││││││└─> UInt64
│││││││┌ @ MethodInstance for >>>(::UInt64, ::UInt64)
│││││││└─> UInt64
│││││││┌ @ MethodInstance for -(::Int64)
│││││││└─> Int64
│││││││┌ @ MethodInstance for unsigned(::Int64)
││││││││┌ @ MethodInstance for reinterpret(::Type{UInt64}, ::Int64)
││││││││└─> UInt64
│││││││└─> UInt64
││││││└─> UInt64
│││││└─> UInt32
│││││┌ @ MethodInstance for &(::UInt32, ::UInt32)
│││││└─> UInt32
││││└─> UInt32
│││└─> UInt32
│││┌ @ MethodInstance for &(::UInt32, ::UInt32)
│││└─> UInt32
│││┌ @ MethodInstance for cody_waite_ext_pio2(::Float64, ::UInt32)
││││┌ @ MethodInstance for /(::Int64, ::Irrational{:π})
│││││┌ @ MethodInstance for promote(::Int64, ::Irrational{:π})
││││││┌ @ MethodInstance for _promote(::Int64, ::Irrational{:π})
│││││││┌ @ MethodInstance for promote_type(::Type{Int64}, ::Type{Irrational{:π}})
││││││││┌ @ MethodInstance for promote_rule(::Type{Int64}, ::Type{Irrational{:π}})
││││││││└─> Type{Union{}}
││││││││┌ @ MethodInstance for promote_rule(::Type{Irrational{:π}}, ::Type{Int64})
││││││││└─> Type{Float64}
││││││││┌ @ MethodInstance for promote_result(::Type{Int64}, ::Type{Irrational{:π}}, ::Type{Union{}}, ::Type{Float64})
││││││││└─> Type{Float64}
│││││││└─> Type{Float64}
│││││││┌ @ MethodInstance for convert(::Type{Float64}, ::Irrational{:π})
│││││││└─> Float64
││││││└─> Tuple{Float64, Float64}
││││││┌ @ MethodInstance for indexed_iterate(::Tuple{Float64, Float64}, ::Int64)
│││││││┌ @ MethodInstance for indexed_iterate(::Tuple{Float64, Float64}, ::Int64, ::Int64)
│││││││└─> Tuple{Float64, Int64}
││││││└─> Tuple{Float64, Int64}
││││││┌ @ MethodInstance for indexed_iterate(::Tuple{Float64, Float64}, ::Int64, ::Int64)
││││││└─> Tuple{Float64, Int64}
││││││┌ @ MethodInstance for not_sametype(::Tuple{Int64, Irrational{:π}}, ::Tuple{Float64, Float64})
││││││└─> Nothing
│││││└─> Tuple{Float64, Float64}
│││││┌ @ MethodInstance for /(::Float64, ::Float64)
│││││└─> Float64
││││└─> Float64
││││┌ @ MethodInstance for /(::Int64, ::Irrational{:π})
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
││││┌ @ MethodInstance for highword(::Float64)
││││└─> UInt32
││││┌ @ MethodInstance for &(::UInt32, ::UInt16)
│││││┌ @ MethodInstance for promote_typeof(::UInt32, ::UInt16)
│││││└─> Type{UInt32}
││││└─> UInt32
││││┌ @ MethodInstance for &(::UInt32, ::UInt16)
│││││┌ @ MethodInstance for rem(::UInt16, ::Type{UInt32})
││││││┌ @ MethodInstance for convert(::Type{UInt32}, ::UInt16)
│││││││┌ @ MethodInstance for UInt32(::UInt16)
││││││││┌ @ MethodInstance for toUInt32(::UInt16)
││││││││└─> UInt32
│││││││└─> UInt32
││││││└─> UInt32
│││││└─> UInt32
│││││┌ @ MethodInstance for &(::UInt32, ::UInt32)
│││││└─> UInt32
││││└─> UInt32
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
││││┌ @ MethodInstance for Base.Math.DoubleFloat64(::Float64, ::Float64)
││││└─> Base.Math.DoubleFloat64
│││└─> Tuple{Int64, Base.Math.DoubleFloat64}
│││┌ @ MethodInstance for cody_waite_2c_pio2(::Float64, ::Float64, ::Int64)
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
│││└─> Tuple{Int64, Base.Math.DoubleFloat64}
│││┌ @ MethodInstance for cody_waite_2c_pio2(::Float64, ::Float64, ::Int64)
││││┌ @ MethodInstance for -(::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
│││└─> Tuple{Int64, Base.Math.DoubleFloat64}
│││┌ @ MethodInstance for cody_waite_2c_pio2(::Float64, ::Float64, ::Int64)
││││┌ @ MethodInstance for -(::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
│││└─> Tuple{Int64, Base.Math.DoubleFloat64}
│││┌ @ MethodInstance for cody_waite_2c_pio2(::Float64, ::Float64, ::Int64)
││││┌ @ MethodInstance for -(::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
│││└─> Tuple{Int64, Base.Math.DoubleFloat64}
│││┌ @ MethodInstance for cody_waite_2c_pio2(::Float64, ::Float64, ::Int64)
││││┌ @ MethodInstance for -(::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
│││└─> Tuple{Int64, Base.Math.DoubleFloat64}
│││┌ @ MethodInstance for cody_waite_2c_pio2(::Float64, ::Float64, ::Int64)
││││┌ @ MethodInstance for -(::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
│││└─> Tuple{Int64, Base.Math.DoubleFloat64}
│││┌ @ MethodInstance for cody_waite_2c_pio2(::Float64, ::Float64, ::Int64)
││││┌ @ MethodInstance for -(::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
│││└─> Tuple{Int64, Base.Math.DoubleFloat64}
│││┌ @ MethodInstance for cody_waite_2c_pio2(::Float64, ::Float64, ::Int64)
││││┌ @ MethodInstance for -(::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
│││└─> Tuple{Int64, Base.Math.DoubleFloat64}
│││┌ @ MethodInstance for cody_waite_2c_pio2(::Float64, ::Float64, ::Int64)
││││┌ @ MethodInstance for -(::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
││││┌ @ MethodInstance for muladd(::Float64, ::Float64, ::Float64)
││││└─> Float64
│││└─> Tuple{Int64, Base.Math.DoubleFloat64}
│││┌ @ MethodInstance for paynehanek(::Float64)
││││┌ @ MethodInstance for &(::UInt64, ::UInt64)
││││└─> UInt64
││││┌ @ MethodInstance for <<(::UInt64, ::Int64)
│││││┌ @ MethodInstance for <=(::Int64, ::Int64)
│││││└─> Bool
│││││┌ @ MethodInstance for unsigned(::Int64)
││││││┌ @ MethodInstance for reinterpret(::Type{UInt64}, ::Int64)
││││││└─> UInt64
│││││└─> UInt64
│││││┌ @ MethodInstance for <<(::UInt64, ::UInt64)
│││││└─> UInt64
│││││┌ @ MethodInstance for -(::Int64)
│││││└─> Int64
│││││┌ @ MethodInstance for unsigned(::Int64)
││││││┌ @ MethodInstance for reinterpret(::Type{UInt64}, ::Int64)
││││││└─> UInt64
│││││└─> UInt64
│││││┌ @ MethodInstance for >>(::UInt64, ::UInt64)
│││││└─> UInt64
││││└─> UInt64
││││┌ @ MethodInstance for |(::UInt64, ::UInt64)
││││└─> UInt64
││││┌ @ MethodInstance for &(::UInt64, ::UInt64)
││││└─> UInt64
││││┌ @ MethodInstance for widemul(::UInt64, ::UInt64)
││││└─> UInt128
││││┌ @ MethodInstance for +(::UInt128, ::UInt128, ::UInt128)
││││└─> UInt128
││││┌ @ MethodInstance for flipsign(::UInt128, ::Float64)
││││└─> UInt128
││││┌ @ MethodInstance for rem(::UInt128, ::Type{Int128})
││││└─> Int128
││││┌ @ MethodInstance for fromfraction(::Int128)
│││││┌ @ MethodInstance for <(::Int128, ::Int64)
││││││┌ @ MethodInstance for <(::Int128, ::Int128)
││││││└─> Bool
│││││└─> Bool
││││└─> Tuple{Float64, Float64}
││││┌ @ MethodInstance for indexed_iterate(::Tuple{Float64, Float64}, ::Int64)
│││││┌ @ MethodInstance for indexed_iterate(::Tuple{Float64, Float64}, ::Int64, ::Int64)
│││││└─> Tuple{Float64, Int64}
││││└─> Tuple{Float64, Int64}
││││┌ @ MethodInstance for indexed_iterate(::Tuple{Float64, Float64}, ::Int64, ::Int64)
││││└─> Tuple{Float64, Int64}
│││└─> Tuple{Int64, Base.Math.DoubleFloat64}
││└─> Tuple{Int64, Base.Math.DoubleFloat64}
││┌ @ MethodInstance for indexed_iterate(::Tuple{Int64, Base.Math.DoubleFloat64}, ::Int64)
│││┌ @ MethodInstance for indexed_iterate(::Tuple{Int64, Base.Math.DoubleFloat64}, ::Int64, ::Int64)
│││└─> Tuple{Union{Int64, Base.Math.DoubleFloat64}, Int64}
│││┌ @ MethodInstance for indexed_iterate(::Tuple{Int64, Base.Math.DoubleFloat64}, ::Int64, ::Int64)
│││└─> Tuple{Union{Int64, Base.Math.DoubleFloat64}, Int64}
││└─> Tuple{Union{Int64, Base.Math.DoubleFloat64}, Int64}
││┌ @ MethodInstance for indexed_iterate(::Tuple{Int64, Base.Math.DoubleFloat64}, ::Int64)
│││┌ @ MethodInstance for indexed_iterate(::Tuple{Int64, Base.Math.DoubleFloat64}, ::Int64, ::Int64)
│││└─> Tuple{Int64, Int64}
││└─> Tuple{Int64, Int64}
││┌ @ MethodInstance for indexed_iterate(::Tuple{Int64, Base.Math.DoubleFloat64}, ::Int64, ::Int64)
││└─> Tuple{Base.Math.DoubleFloat64, Int64}
││┌ @ MethodInstance for &(::Int64, ::Int64)
││└─> Int64
││┌ @ MethodInstance for sin_kernel(::Base.Math.DoubleFloat64)
│││┌ @ MethodInstance for getproperty(::Base.Math.DoubleFloat64, ::Symbol)
│││└─> Float64
│││┌ @ MethodInstance for getproperty(::Base.Math.DoubleFloat64, ::Symbol)
│││└─> Float64
│││┌ @ MethodInstance for getproperty(::Base.Math.DoubleFloat64, ::Symbol)
│││└─> Float64
││└─> Float64
││┌ @ MethodInstance for cos_kernel(::Base.Math.DoubleFloat64)
││└─> Float64
│└─> Float64
└─> Float64
```
