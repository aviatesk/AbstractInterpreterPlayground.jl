using AbstractInterpreterPlayground, Test
import Core.Compiler:
    ⊑

@testset "AbstractInterpreterPlayground.jl" begin
    # basic end to end
    interp, frame = @enter_call rand(Bool)
    @test frame.result.result ⊑ Bool
end
