function (f::LFT)(R::CoinRepresentation{T}) where {T}
    new_circs = Dict{T,Circle}()

    for v ∈ keys(R.circs)
        new_circs[v] = f(R[v])
    end
    return CoinRepresentation(new_circs)
end



function (f::LFT)(RR::DualCoinRepresentation{T}) where {T}
    new_circs = Dict{T,Circle}()
    new_dual_circs = Dict{Set{T},Circle}()

    for v ∈ keys(RR.circs)
        new_circs[v] = f(RR.circs[v])
    end

    for F ∈ keys(RR.dual_circs)
        new_dual_circs[F] = f(RR.dual_circs[F])
    end

    return DualCoinRepresentation(new_circs, new_dual_circs)
end
