using Merlin

if haskey(ENV, "USE_CUDA")
  using CUDA
  using CUDNN
end

if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

tests = ["functions"]
#"graphs"

for t in tests
    path = joinpath(dirname(@__FILE__), "$t.jl")
    println("$path ...")
    include(path)
end
