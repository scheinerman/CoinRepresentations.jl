using SimpleGraphs, SimpleDrawing, CoinRepresentations

function spider_web()

    # Create the graph as the Cartesian product of a 7-cycle 
    # and a 3-path, relabeled 1 through 21.
    G = relabel(Cycle(7) * Path(3))

    # Choose a (facial) seven-cycle of this graph and use it to 
    # create a planar embedding.
    F = [1, 4, 7, 10, 13, 16, 19]
    embed(G, :tutte, outside = F)

    # Use the planar embedding to create the RotationSystem for this graph
    # so it can be used by the CoinRepresentation methods.
    embed_rot(G)

    # Draw the graph and its duals with straight line segments so that
    # dual edges cross at right angles.
    ortho_draw(G, F)
end
