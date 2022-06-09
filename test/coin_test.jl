GraphTheory()
using Clines, SimplePlanarGraphs, CoinRepresentations

G = Dodecahedron()
R = CoinRepresentation(G)
draw(R)