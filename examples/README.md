# Examples for `CoinRepresentations`


## `coin_examples.jl`

The  graph `G` used in these examples is the dodecahedron graph.


This file defines three functions to illustrate coin representations
of three-connected planar graphs. 
* `coin_ex()` shows a coin representation of `G`.
* `dual_coin_ex()` shows a coin representation together with a coin representation of `G`'s dual.
* `orth_ex()` shows a drawing of `G` and its dual where all edges are straight line segments and dual edges intersect at right angles.

## `coin_lft_examples.jl`

The  graph `G` used in these examples is the dodecahedron graph.

This file demonstrates how a linear fractional transformation may be applied to a coin representation. In these examples, the transformation is 
`f(z) = z/(z+1)`.

* `coin_lft_ex()` shows the coin representation of the graph after applying `f`.
* `dual_coin_lft_ex()` shows the dual coin representation of the graph after applying `f`.

## `spider_web.jl`

This shows how to give a graph that the user knows to be three-conected and planar, but does not have a Rotation System defined.

The function `spider_web` creates a (relabeled version of) the Cartesian product of a 7-cycle and a 3-path. A planar embedding is created using a known face. That embedding is, in turn, used to generate a rotation system as needed by this module. Finally, the graph and its dual are drawn. In this drawing dual edges cross each other at right angles. 