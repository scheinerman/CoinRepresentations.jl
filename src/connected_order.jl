"""
    connected_order(G::SimpleGraph)
Return a list of the vertices of `G` such that the induced graph 
on every initial segment of that list is connected.
"""
function connected_order(G::SimpleGraph{TT}) where {TT}
    if !is_connected(G)
        error("Graph must be connected")
    end

    T = deepcopy(spanning_forest(G))
    list = TT[]

    if NV(G) == 0
        return list
    end

    while NV(T) > 1
        v = find_leaf(T)
        push!(list, v)
        delete!(T, v)
    end
    push!(list, first(T.V))

    return reverse(list)
end



function find_leaf(T::SimpleGraph)
    VV = vlist(T)
    degs = [deg(T, v) == 1 for v in VV]
    i = findfirst(degs)
    return VV[i]
end
