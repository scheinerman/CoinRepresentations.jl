
"""
    center_embed(G::SimpleGraph)
Given a (3-connected, planar) graph `G`, use the centers of 
its coin representation to embed `G`.
"""
function center_embed(G::SimpleGraph{T}) where {T}
    rep = coin_rep(G)

    d = Dict{T,Vector{Float64}}()
    for v ∈ G.V
        z = center(rep[v])
        d[v] = collect(reim(z))
    end

    embed(G, d)
end
