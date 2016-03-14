type ReLU <: Functor
end

function forward!(f::ReLU, v::Variable)
  x = v[1].value
  cond = x >= 0.0
  v.value = cond .* x
  v.work = cond
end

function backward!(f::ReLU, v::Variable)
  cond = v.work
  gx = v.grad .* cond
  addgrad!(v[1], gx)
  #addgrad!(v[1], zeros(v[1].value))
end

function relu{T,N}(x::Array{T,N})
  y = alloc_cpu(T, size(x))
  for i = 1:length(x)
    xx = x[i]
    y[i] = xx > T(0) ? xx : T(0)
  end
  y
end

function backward2!(f::ReLU, v::Variable)
  gx = ∇relu(v[1].value, v.grad)
  addgrad!(v[1], gx)
end

function ∇relu{T,N}(x::Array{T,N}, gy::Array{T,N})
  gx = alloc_cpu(T, size(x))
  for i = 1:length(x)
    #d = x[i] > T(0) ? gy[i] : p * gy[i]
    d = x[i] > T(0) ? gy[i] : T(0)
    gx[i] = d
  end
  gx
end

#function ∇relu{T,N}(varx::CudaArray{T,N}, vary::CudaArray{T,N})
#  x, gx = data(varx)
#  y, gy = data(vary)
#  CUDNN.activation_backward(CUDNN.ACTIVATION_RELU, x, dx, y, dy)
#end