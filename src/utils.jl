function ptp(x::AbstractArray{<:AbstractFloat, 1})
  return maximum(x) - minimum(x)
end

function ptp(x::AbstractArray{<:Complex{<:AbstractFloat}, 1})
  @views re′ = x_[1:2:end]
  @views im′ = x_[2:2:end]
  
  return ptp(re′) + 1.0im * ptp(im′)
end

function ptp(x::AbstractArray{<:AbstractFloat, N}, dims) where N
  return maximum(x, dims=dims) - minimum(x, dims=dims)
end

function ptp(x::AbstractArray{<:Complex{<:AbstractFloat}, N}, dims) where N
  x_ = reinterpret(Float64, x)
  @views re′ = reshape(x_[1:2:end], size(x)...)
  @views im′ = reshape(x_[2:2:end], size(x)...)
  
  return ptp(re′, dims) + 1.0im * ptp(im′, dims)
end