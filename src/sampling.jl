"""
  Rudimentary adaptive function sampling
  Adapted from https://stackoverflow.com/a/14084715
"""
function sample_function(func, nodes, values=func.(nodes), mask=Colon(); 
    depth=0, min_nodes=16, max_level=16, tol=0.01)

  if depth > max_level
    return nodes, values
  end
  
  # Calculate the function in between the nodes
  x_c = 0.5 * (nodes[1:end-1][mask] + nodes[2:end][mask])
  y_c = func.(x_c)

  x₂ = vcat(nodes, x_c)
  y₂ = vcat(values, y_c)
  is = sortperm(x₂)

  x₂ = x₂[is]
  y₂ = y₂[is]

  # Determine where to refine
  if length(x₂) < min_nodes
    mask = trues(length(x₂) - 1)
  else
    # Rescale and compute the length of each line segment in the path
    dx = diff(x₂) / ptp(x₂)
    dy = diff(y₂) / abs(ptp(y₂))
    ds = sqrt.(abs2.(dx) + abs2.(dy))
    
    # Compute the angle between consecutive line segments θ = acos(a⋅b / (|a||b|))
    dx ./= ds
    dy ./= ds

    if eltype(dy) <: Complex
      @views dy_re = reinterpret(Float64, dy)[1:2:end]
      @views dy_im = reinterpret(Float64, dy)[2:2:end]
      dθ = acos.(clamp.(dx[2:end] .* dx[1:end-1] + dy_re[2:end] .* dy_re[1:end-1] + dy_im[2:end] .* dy_im[1:end-1], -1, 1))
    else
      dθ = acos.(clamp.(dx[2:end] .* dx[1:end-1] + dy[2:end] .* dy[1:end-1], -1, 1))
    end

    # Determine where to subdivide (total length of the path is computed ≈ to accuracy `tol`)
    mask = 0.5 * dθ .* (ds[2:end] .+ ds[1:end-1]) .> tol * sum(ds)
    mask = [mask; false]
    mask[2:end] .|= mask[1:end-1]
  end
  
  # Refine!
  if any(mask)
    return sample_function(func, x₂, y₂, mask; tol=tol, depth=depth+1, min_nodes=min_nodes, max_level=max_level)
  else
    return x₂, y₂
  end
end
