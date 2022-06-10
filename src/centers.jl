export centers, draw_rep

"""
    centers(G,vrad,frad)

Compute the centers of the vertex circles and the face circles of `G`
given their radii. Returns two dictionaries; one for the vertex centers
and one for the face centers.
"""
function centers(
    G::SimpleGraph{T},
    v_rad::Dict{T,Float64},
    f_rad::Dict{Set{T},Float64},
) where {T}
    n = NV(G)
    FT = Set{T}
    v_ctr = Dict{T,Complex{Float64}}()
    f_ctr = Dict{FT,Complex{Float64}}()
    GG = dual(G)

    dd = directed_dual_edges(G)
    verts = connected_order(G)

    # center the first vertex circle at (0,0)
    v = verts[1]
    v_ctr[v] = 0im

    # choose any face containing v and place its center on the +x axis
    v_faces = [f for f ∈ GG.V if v ∈ f]
    f = Set(first(v_faces))

    x = sqrt(v_rad[v]^2 + f_rad[f]^2)
    f_ctr[f] = x + 0im

    for i ∈ 1:n
        v = verts[i]  # complete the flower around v 
        vertex_flower = collect(get_rot(G, v))  # ring list of v's neighbors

        out_edges = [(v, x) for x in vertex_flower]
        dual_out_edges = [dd[e] for e in out_edges]

        face_flower = [Set(first(dd[e])) for e in out_edges]
        face_ring = RingList(face_flower)



        # pick a face that already has its center defined
        defined_ctrs = [f for f in face_flower if haskey(f_ctr, f)]
        f0 = defined_ctrs[1]


        vec = f_ctr[f0] - v_ctr[v]
        theta = angle(vec)

        f = f0
        while true      # march around the faces, find them centers
            f = next(face_ring, f)

            if f == f0
                break
            end

            if haskey(f_ctr, f)  # skip faces we already have centered
                continue
            end

            g = previous(face_ring, f)  # prior face (already centered)
            theta = angle(f_ctr[g] - v_ctr[v])   # angle of vector to center of g 

            theta += atan(f_rad[g], v_rad[v])    # angle of vector to point of g-f tangency
            theta += atan(f_rad[f], v_rad[v])   # angle of vector to ctr of f 

            dist = sqrt(v_rad[v]^2 + f_rad[f]^2)
            z = v_ctr[v] + dist * exp(im * theta)

            f_ctr[f] = z
        end

        # now we find the center of the next vertex circle
        if i == n   # no more centers to find
            break
        end


        w = verts[i+1]  # next vertex to consider

        # find a vertex to which w is adjacent that we've already handled
        vv = first([x for x in verts[1:i] if G[w, x]])


        fx, fy = Set.(dd[vv, w])


        p = tangent_point(f_ctr[fx], f_rad[fx], f_ctr[fy], f_rad[fy])  # tangency between two centers


        uvec = p - v_ctr[vv]
        uvec /= abs(uvec)     # unit vector from v center toward w center 

        v_ctr[w] = v_ctr[vv] + (v_rad[vv] + v_rad[w]) * uvec



        # break
    end


    return v_ctr, f_ctr
end

"""
    draw_rep(r,rr,z,zz)
"""
function draw_rep(
    v_rad::Dict{T,Float64},
    f_rad::Dict{Set{T},Float64},
    v_ctr::Dict{T,Complex{Float64}},
    f_ctr::Dict{Set{T},Complex{Float64}},
) where {T}
    annotation = false
    newdraw()

    dual_color = :red

    for f in keys(f_ctr)
        z = f_ctr[f]
        rad = f_rad[f]
        C = Circle(z, f_rad[f] |> abs)
        if rad > 0
            draw(C, linecolor = dual_color)
        else
            draw(C, linecolor = dual_color, linestyle = :dot)
        end

        annotation && annotate!(real(z), imag(z), "$f")
    end


    for v ∈ keys(v_ctr)
        z = v_ctr[v]
        C = Circle(z, v_rad[v])
        draw(C)
        annotation && annotate!(real(z), imag(z), "$v")
    end

    finish()

end

"""
    tangent_point(c,r,cc,rr)
Given tangent circles with centers `c` and `cc` 
and radii `r` and `rr` find the point of tangency
between the two circles. 
"""
function tangent_point(c::Complex, r::Real, cc::Complex, rr::Real)

    d = r + rr
    t = r / d
    z = c + t * (cc - c)

    return z
end

tangent_point(C1::Circle, C2::Circle) =
    tangent_point(center(C1), radius(C1), center(C2), radius(C2))
