
export VF

"""
    VF(G, out_face)
Given a (planar) graph create a data structure that includes a vertex-face incidence 
graph. The main part of this structure is a graph `VFG` whose first `n` vertices 
correspond to the vertices of `G` and whose next `f` vertices correspond to the faces. 
"""
struct VF
    Vlist::Vector               # list of vertices
    Flist::Vector               # list of faces (as sets of vertices)
    Vlookup::Dict               # map vertex to index in Vlist
    Flookup::Dict               # map face to index in Flist (starting from NV(G)+1)
    VFgraph::SimpleGraph{Int}   # vertex-face incidence graph using indices
    out::Int                    # index of the outside face

    function VF(G::SimpleGraph, out_face::Set = Set{Int}())
        Vlist = vlist(G)
        GG = dual(G)
        Flist = Set.(GG.V)

        Vlookup = Dict{eltype(Vlist),Int}()
        for i = 1:length(Vlist)
            v = Vlist[i]
            Vlookup[v] = i
        end

        Flookup = Dict{eltype(Flist),Int}()
        for i = 1:length(Flist)
            f = Flist[i]
            Flookup[f] = i + NV(G)
        end


        # this graph contains a copy of G, a copy of G's dual,
        # and the vertex-face indicidences
        #
        # vertices 1 through nv correspond to G 
        # vertices nv+1 through nv+nf correspond to G's dual

        VFG = SimpleGraph{Int}()

        for e in G.E
            v, w = e
            i = Vlookup[v]
            j = Vlookup[w]
            add!(VFG, i, j)
        end

        for e in GG.E
            v, w = e
            i = Flookup[Set(v)]
            j = Flookup[Set(w)]
            add!(VFG, i, j)
        end


        for f in Flist
            i = Flookup[f]
            for v ∈ f
                j = Vlookup[v]
                add!(VFG, i, j)
            end
        end

        out = findfirst((F == out_face) for F ∈ Flist)
        if isnothing(out)
            out = NV(VFG)
            @info "Selecting $(last(Flist)) as outside face"
        else
            out += NV(G)
        end
        # println("Outside face index = $out")
        new(Vlist, Flist, Vlookup, Flookup, VFG, out)
    end
end
