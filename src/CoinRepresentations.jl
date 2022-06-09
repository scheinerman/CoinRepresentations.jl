module CoinRepresentations

using SimpleGraphs, Clines, RingLists, NLsolve
using LinearFractionalTransformations, SimpleDrawing, Plots

import SimpleDrawing: draw
import Base: getindex, keys, values, show, length

NL_OPTS = Dict{Symbol,Any}()
NL_OPTS[:show_trace] = false
# NL_OPTS[:ftol] = 1e-12
# NL_OPTS[:iterations] = 2_000

include("dual_edges.jl")
include("connected_order.jl")
include("VF.jl")
include("radii.jl")
include("centers.jl")

export CoinRepresentation

"""
    CoinRepresentation(G::SimpleGraph, F)

Given a planar, three-connected graph `G` and its outer face `F`
construct a coin representation of `G`. `F` may be specified either as
a `Vector` or a `Set` of vertices of `G`.

If `F` is omitted (or invalid) a face will be automatically selected.
"""
struct CoinRepresentation{T}
    circs::Dict{T,Circle}

    function CoinRepresentation(G::SimpleGraph{T}, F::Set{T} = Set{T}()) where {T}
        r, rr = radii(G, F)
        z, zz = centers(G, r, rr)
        cc = Dict{T,Circle}()

        for v ∈ G.V
            cc[v] = Circle(z[v], r[v])
        end
        new{T}(cc)
    end

    function CoinRepresentation(cdict::Dict{T,Circle}) where {T}
        new{T}(cdict)
    end
end

function CoinRepresentation(G::SimpleGraph{T}, F::Vector{T}) where {T}
    CoinRepresentation(G, Set(F))
end


function draw(R::CoinRepresentation, fill::Symbol = :yellow)
    newdraw()
    for C in values(R.circs)
        if fill == :none
            draw(C)
        else
            draw(C, true, color = fill)
        end
    end
    finish()
end

function getindex(R::CoinRepresentation{T}, v::T)::Circle where {T}
    return R.circs[v]
end

keys(R::CoinRepresentation) = keys(R.circs)
values(R::CoinRepresentation) = values(R.circs)
length(R::CoinRepresentation) = length(R.circs)

function show(io::IO, R::CoinRepresentation)
    print(io, "CoinRepresentation of a graph with $(length(R)) vertices")
end


function (f::LFT)(R::CoinRepresentation{T}) where {T}
    new_circs = Dict{T,Circle}()

    for v ∈ keys(R.circs)
        new_circs[v] = f(R[v])
    end
    return CoinRepresentation(new_circs)
end


end # module
