# Examples for `CoinRepresentations`

The  graph `G` used in these examples is the dodecahedron graph.

## `coin_examples.jl`

This file defines three functions to illustrate coin representations
of three-connected planar graphs. 
* `coin_ex()` shows a coin representation of `G`.
* `dual_coin_ex()` shows a coin representation together with a coin representation of `G`'s dual.
* `orth_ex()` shows a drawing of `G` and its dual where all edges are straight line segments and dual edges intersect at right angles.

## `coin_lft_examples.jl`

This file demonstrates how a linear fractional transformation may be applied to a coin representation. In these examples, the transformation is 
`f(z) = z/(z+1)`.

* `coin_lft_example()` shows the coin representation of the graph after applying `f`.
* `dual_coin_lft_example()` shows the dual coin representation of the graph after applying `f`.