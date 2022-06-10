using CoinRepresentations, Clines, SimpleDrawing, Plots
GraphTheory()

struct DualCoinRepresentation{T}
    circs::Dict{T,Circle}
    dual_circs::Dict{Set{T},Circle}

    function DualCoinRepresentation(G::SimpleGraph{T}, F::Set{T} = Set{T}()) where T
        r, rr = radii(G, F)
        z, zz = centers(G, r, rr)
        cc = Dict{T,Circle}()
        dc = Dict{Set{T}, Circle}()
        for v ∈ G.V
            cc[v] = Circle(z[v], r[v])
        end

        for f in keys(rr)
            c = zz[f]
            rad = abs(rr[f])
            dc[f] = Circle(c,rad)
        end
        new{T}(cc,dc)
    end
end