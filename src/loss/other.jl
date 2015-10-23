
# ==========================================================================
# L(y, t) = - y*ln(t) - (1-y)*ln(1-t)

immutable CrossentropyLoss <: SupervisedLoss end
typealias LogitProbLoss CrossentropyLoss

function value(l::CrossentropyLoss, y::Number, t::Number)
  if y == 1
    -log(t)
  elseif y == 0
    -log(1 - t)
  else
    -y*log(t) - (1-y)*log(1-t)
  end  
end
deriv(l::CrossentropyLoss, y::Number, t::Number) = t - y
deriv2(l::CrossentropyLoss, y::Number, t::Number) = 1
value_deriv(l::CrossentropyLoss, y::Number, t::Number) = (value(l,y,t), deriv(l,y,t))

isdifferentiable(::CrossentropyLoss) = true
isconvex(::CrossentropyLoss) = true

# ==========================================================================
# L(y, t) = sign(yt) < 0 ? 1 : 0

immutable ZeroOneLoss <: SupervisedLoss end

call(l::ZeroOneLoss, yt::Number) = value(l, yt)
transpose(l::ZeroOneLoss) = repr_deriv_fun(l)
value(l::ZeroOneLoss, y::Number, t::Number) = value(l, y * t)
deriv(l::ZeroOneLoss, y::Number, t::Number) = zero(t)
deriv2(l::ZeroOneLoss, y::Number, t::Number) = zero(t)

value{T<:Number}(l::ZeroOneLoss, yt::T) = sign(yt) < 0 ? one(T) : zero(T)
deriv{T<:Number}(l::ZeroOneLoss, yt::T) = zero(T)
deriv2{T<:Number}(l::ZeroOneLoss, yt::T) = zero(T)

function repr_fun(l::ZeroOneLoss)
  _φ(yt::Number) = value(l, yt)
  _φ
end

function repr_deriv_fun(l::ZeroOneLoss)
  _φ_deriv(yt::Number) = deriv(l, yt)
  _φ_deriv
end

function repr_deriv2_fun(l::ZeroOneLoss)
  _φ_deriv2(yt::Number) = deriv2(l, yt)
  _φ_deriv2
end

isdifferentiable(::ZeroOneLoss) = false
isconvex(::ZeroOneLoss) = false
isclasscalibrated(l::ZeroOneLoss) = true
