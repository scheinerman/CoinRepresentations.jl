export radii

"""
    radii(G::UG{T}, out_face::Set{T})
Compute the radii of the 
circles in the dual coin representation of the 3-connected planar graph `G`.
The `out_face` argument is optional in which case a face is arbitrarily chosen
to be the outside.

We return a two-tuple:
* A dictionary giving the vertex radii
* A dictionary giving the face radii
"""
function radii(VFX::VF)

    GG = VFX.VFgraph
    nn = NV(GG)

    nv = length(VFX.Vlist)
    nf = length(VFX.Flist)

    out = VFX.out
    # @info "Outside face index = $out --> $(VFX.Flist[out-nv])"


    function eqns!(y, r)
        nn = NV(GG)
        for v = 1:nn
            Nv = GG[v]
            if v ≤ nv
                Nv = Nv ∩ Set(nv+1:nn)
            else
                Nv = Nv ∩ Set(1:nv)
            end

            if out ∈ Nv
                y[v] = sum(atan(r[w] / r[v]) for w ∈ Nv)
            else
                y[v] = sum(atan(r[w] / r[v]) for w ∈ Nv) - π
            end

        end
        y[out] = r[out] + nn
        return y
    end




    r = ones(nn)
    r[out] = -nn
    X = nlsolve(eqns!, r; NL_OPTS...)

    if !X.f_converged
        @warn "Nonconvergence of radii"
    end

    r = X.zero


    vrads = Dict{eltype(VFX.Vlist),Float64}()

    for idx = 1:nv
        v = VFX.Vlist[idx]
        vrads[v] = r[idx]
    end

    frads = Dict{eltype(VFX.Flist),Float64}()


    for idx = 1:nf
        f = VFX.Flist[idx]
        frads[f] = r[idx+nv]
    end

    return vrads, frads
end



function radii(G::UG{T}, out_face::Set = Set{T}()) where {T}
    VFX = VF(G, out_face)
    return radii(VFX)
end


radii(G::UG{T}, out_face::Vector{T}) where {T} = radii(G, Set(out_face))
