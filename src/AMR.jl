module AMR

export sample_function

ptp(x) = argmax(abs, x) - argmin(abs, x)

include("sampling.jl")

end # module