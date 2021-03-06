
"""
    center_embed(G::UG, R::CoinRepresentation)
Given a (3-connected, planar) graph `G` and coin representation,
embed `G` by placing vertices of their respective coins. 
"""
function center_embed(G::UG{T}, R::CoinRepresentation{T}) where {T}
    newxy = Dict{T,Vector{Float64}}()
    for v ∈ G.V
        z = center(R[v])
        newxy[v] = collect(reim(z))
    end

    embed(G, newxy)
end

export center_embed
