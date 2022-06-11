using SimpleGraphs, SimpleDrawing, CoinRepresentations, LinearFractionalTransformations

function coin_lft_ex()
    G = Dodecahedron()
    f = LFT(1, 0, 1, 1)
    R = CoinRepresentation(G)
    draw(f(R))
end

function dual_coin_lft_ex()
    G = Dodecahedron()
    f = LFT(1, 0, 1, 1)
    RR = DualCoinRepresentation(G)
    draw(f(RR))
end
