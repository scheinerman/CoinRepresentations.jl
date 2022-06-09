module CoinRepresentations

using SimpleGraphs, Clines, RingLists, NLsolve
using LinearFractionalTransformations, SimpleDrawing, Plots

import SimpleDrawing: draw

NL_OPTS = Dict{Symbol, Any}()
NL_OPTS[:show_trace] = false
# NL_OPTS[:ftol] = 1e-12
# NL_OPTS[:iterations] = 2_000

include("dual_edges.jl")
include("connected_order.jl")
include("VF.jl")
include("radii.jl")
include("centers.jl")

function draw(rep::Dict{T,Circle}) where {T}
    for C in values(rep)
        draw(C)
    end
    finish()
end


function (f::LFT)(rep::Dict{T,Circle}) where {T}
    new_rep = Dict{T,Circle}()
    for v ∈ keys(rep)
        new_rep[v] = f(rep[v])
    end
    return new_rep
end

end # module
