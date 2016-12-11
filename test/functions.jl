const T = Float32

@testset "functions" for i = 1:5

# concat
x1 = Var(rand(T,10,5,2))
x2 = Var(rand(T,10,5,2))
x3 = Var(rand(T,10,5,2))
for dim = 1:3
    @test checkgrad(()->concat(dim,x1,x2,x3), x1, x2, x3)
    @test checkcuda(()->concat(dim,x1,x2,x3), x1, x2, x3)
end

# crossentropy
p = Var([1:5;])
x = Var(rand(T,10,5))
@test checkgrad(()->crossentropy(p,x), x)

# gemm
x1 = Var(rand(T,10,5))
x2 = Var(rand(T,5,10))
x3 = Var(rand(T,10,5))
@test checkgrad(()->gemm('N','N',T(0.2),x1,x2), x1, x2)
@test checkgrad(()->gemm('N','T',T(0.3),x1,x3), x1, x3)
@test checkgrad(()->gemm('T','N',T(0.4),x1,x3), x1, x3)
@test checkgrad(()->gemm('T','T',T(0.5),x1,x2), x1, x2)

# linear
x = Var(rand(T,10,5))
f = Linear(T, 10, 7)
f.b = Var(rand(T,size(f.b)))
@test checkgrad(()->f(x), f.w, x, f.b)
@test checkcuda(()->f(x), f.w, x, f.b)

# math
x1 = Var(rand(T,10,5))
x2 = Var(rand(T,10,5))
x3 = Var(rand(T,10,5))
for op in (+,-,.*)
    @test checkgrad(()->op(x1,x2), x1, x2)
    @test checkgrad(()->op(x1,x3), x1, x3)
    @test checkgrad(()->op(x3,x1), x3, x1)
end
x4 = Var(rand(T,5,7))
@test checkgrad(()->x1*x4, x1, x4)

# sigmoid
x = Var(rand(T,5,4))
@test checkgrad(()->sigmoid(x), x)
@test checkcuda(()->sigmoid(x), x)

# softmax
x = Var(rand(T,10,5,3,4))
for f in (softmax,logsoftmax)
    @test checkgrad(()->f(x), x)
    @test checkcuda(()->f(x), x)
end

# tanh
x = Var(rand(T,5,4))
@test checkgrad(()->tanh(x), x)
@test checkcuda(()->tanh(x), x)

# window
x = Var(rand(T,100))
@test checkgrad(()->window(x,(30,),pads=(10,),strides=(10,)), x)

#=
@testset "reduce" begin
    x = Var(rand(T,10,5))
    #@test checkgrad(sum, x, 1)
    #@test checkgrad(sum, x, 2)
end

=#

#=
x = Var(rand(T,5,4,3,2))
f = Convolution(T, (2,2), (3,4), (0,0), (1,1))
@test checkgrad(f, x)

=#

#x = Var(rand(T,5,4,3,2))
#f = Conv(T, (2,2), (3,4), stride=(1,1), paddims=(0,0))
#@test checkgrad(()->f(x), f.w, x)

#=

xx = Var(rand(T,1)[1])
@test checkgrad(()->exp(x1), x1)
#@test checkgrad(()->exp(xx), xx) # TODO: fail test
#@test checkgrad(()->log(x1), x1) # TODO: fail test
x1 = Var(rand(T,10,5))
#@test checkgrad(()->dropout(x1,0.5,true), x1)

x = Var(rand(T,10,5,4,3))
for dim = 1:ndims(x.data)
    @test checkgrad(()->sum(x,dim), x)
end

x = Var(rand(T,100,1))
h = Var(rand(T,100,1))
f = GRU(T, 100)
@test checkgrad(()->f(x,h), x, h)

=#

end
