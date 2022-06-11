using SimpleGraphs, SimpleDrawing, CoinRepresentations, LinearFractionalTransformations

function coin_lft_example()
    G = Dodecahedron()
    f = LFT(1,0,1,1)
    R = CoinRepresentation(G)
    draw(f(R))
end