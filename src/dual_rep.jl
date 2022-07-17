export DualCoinRepresentation
"""
    DualCoinRepresentation(G,F)
Same as `CoinRepresentation` but creates circles both for the graph and its dual.
Access the results as `RR.circs` and `RR.dual_circs`.
"""
struct DualCoinRepresentation{T}
    circs::Dict{T,Circle}
    dual_circs::Dict{Set{T},Circle}

    function DualCoinRepresentation(G::UG{T}, F::Set{T} = Set{T}()) where {T}
        r, rr = radii(G, F)
        z, zz = centers(G, r, rr)
        cc = Dict{T,Circle}()
        dc = Dict{Set{T},Circle}()
        for v ∈ G.V
            cc[v] = Circle(z[v], r[v])
        end

        for f in keys(rr)
            c = zz[f]
            rad = abs(rr[f])
            dc[f] = Circle(c, rad)
        end
        new{T}(cc, dc)
    end

    function DualCoinRepresentation(
        v_dict::Dict{T,Circle},
        f_dict::Dict{Set{T},Circle},
    ) where {T}
        new{T}(v_dict, f_dict)
    end

end

DualCoinRepresentation(G::UG{T}, F::Vector{T}) where {T} =
    DualCoinRepresentation(G, Set(F))

function draw(RR::DualCoinRepresentation, fill::Symbol = :yellow)
    newdraw()
    for C ∈ values(RR.circs)
        if fill == :none
            draw(C)
        else
            draw(C, true, color = fill)
        end
    end

    for C ∈ values(RR.dual_circs)
        draw(C, linestyle = :dot)
    end
    finish()

end


function show(io::IO, RR::DualCoinRepresentation{T}) where {T}
    print(io, "DualCoinRepresentation{$T} of a graph with $(length(RR.circs)) vertices")
end
