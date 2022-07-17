export ortho_draw

"""
    ortho_draw(G::UG, F)

Given a three-connected planar graph `G` create straight-line 
drawing of `G` and its dual so that dual edges cross at right angles.
The face `F` may be specified either as a list or a set (and is optional).
"""
function ortho_draw(G::UG{T}, F::Set{T} = Set{T}()) where {T}
    r, rr = radii(G, F)
    z, zz = centers(G, r, rr)
    GG = dual(G)

    dd = directed_dual_edges(G)

    newdraw()

    vsize = 4

    # draw G 
    for e ∈ G.E
        u, v = e
        draw_segment(z[u], z[v], linecolor = :black)
    end
    for v ∈ G.V
        draw_point(z[v], linecolor = :black, color = :white, marker = vsize)
    end

    # draw the edges of the dual of G except for unbounded face

    for e ∈ GG.E
        f1, f2 = Set.(e)
        if rr[f1] > 0 && rr[f2] > 0
            draw_segment(zz[f1], zz[f2], linecolor = :black, linestyle = :dot)
        end
    end

    # find the unbounded face (negative radius)
    negF = first([f for f in GG.V if rr[Set(f)] < 0])

    for F ∈ GG[negF]
        u, v = dd((negF, F))
        p = tangent_point(z[u], r[u], z[v], r[v])
        f = Set(F)
        vec = 2 * (p - zz[f])

        draw_segment(zz[f], zz[f] + vec, linecolor = :black, linestyle = :dot)

    end







    for v in GG.V
        f = Set(v)
        if rr[f] > 0
            draw_point(zz[f], linecolor = :black, color = :white, marker = vsize)
        end
    end



    finish()

end

ortho_draw(G::UG{T}, F::Vector{T}) where {T} = ortho_draw(G, Set(F))
