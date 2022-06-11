using SimpleGraphs, SimpleDrawing, CoinRepresentations


function coin_ex()
    G = Dodecahedron()
    R = CoinRepresentation(G)
    draw(R)
end

function dual_coin_ex()
    G = Dodecahedron()
    RR = DualCoinRepresentation(G)
    draw(RR)
end

function ortho_ex()
    G = Dodecahedron()
    ortho_draw(G)
end
