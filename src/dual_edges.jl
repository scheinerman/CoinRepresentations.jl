using SimpleGraphs
using Bijections, RingLists


"""
    dual_edges(G::SimpleGraph)
Given a (3-connected, planar) graph `G` create a `Bijection` `d`
between the edges of `G` and the edges of its dual.

+ If `e` is an edge of `G`, then `d[e]` is its dual edge.
+ If `e` is an edge of the dual of `G`, then `d(e)` is its dual edge.
"""
function dual_edges(G::SimpleGraph{T}) where {T}
    GG = dual(G)

    ET = eltype(G.E)
    FT = eltype(GG.E)
    d = Bijection{ET,FT}()

    for ee ∈ GG.E      # ee is an edge of the dual
        f1, f2 = ee
        u, v = f1 ∩ f2  # these are the endpoints of the edge dual to ee
        e = get_edge(G, u, v)
        d[e] = ee
    end

    return d
end

"""
    directed_dual_edges(G)

Create a bijection `d` from directed edges of `G` to the directed 
edges of its dual. Given an edge from `u` pointing to `v`, then `d[u,v]`
will be a tuple of faces `f,ff` so that the dual edge `(f,ff)` crosses
`(u,v)` from right to left. 
"""
function directed_dual_edges(G::SimpleGraph{T}) where {T}
    GG = dual(G)

    ET = eltype(G.E)
    FT = eltype(GG.E)

    dd = Bijection{ET,FT}()

    d = dual_edges(G)

    for e in keys(d)
        u, v = e
        f, ff = d[e]

        Nu = get_rot(G, u)
        uu = next(Nu, v)
        if uu ∉ ff
            f, ff = ff, f
        end
        dd[u, v] = f, ff
        dd[v, u] = ff, f

    end

    return dd

end
