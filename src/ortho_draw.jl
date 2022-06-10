GraphTheory()
using CoinRepresentations


function ortho_draw(G::SimpleGraph{T}, F::Set{T} = Set{T}()) where {T}
    r, rr = radii(G, F)
    z, zz = centers(G, r, rr)
    GG = dual(G)

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

    # draw the dual of G 

    for e ∈ GG.E
        f1, f2 = Set.(e)
        if rr[f1] > 0 && rr[f2] > 0
            draw_segment(zz[f1], zz[f2], linecolor = :black, linestyle = :dot)
        end
    end

    for v in GG.V
        f = Set(v)
        if rr[f] > 0
            draw_point(zz[f], linecolor = :black, color = :white, marker = vsize)
        end
    end



    finish()

end

ortho_draw(G::SimpleGraph{T}, F::Vector{T}) where {T} = ortho_draw(G, Set(F))
