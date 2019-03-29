function *(s::Shell{Nothing}, obj::AbstractPrimitive{N,T}) where {N,T}
    Shell(obj, s.distance)
end

function *(a::Transform{N,T}, b::Transform{N,T}) where {N,T}
    Transform{N,T}(a.transform*b.transform)
end

function rotate(ang, vect::Vector)
    n = length(vect)
    N = n + 1
    transform = Matrix(1.0*I,4,4)
    sin_ang = sin(ang)
    cos_ang = cos(ang)

    # axis rotations
    if vect[1] != 0
        transform[2,2] = transform[3,3] = cos_ang
        transform[2,3] = -sin_ang
        transform[3,2] = sin_ang
    elseif vect[2] != 0
        transform[1,1] = transform[3,3] = cos_ang
        transform[1,3] = sin_ang
        transform[3,1] = -sin_ang
    elseif vect[3] != 0
        transform[1,1] = transform[2,2] = cos_ang
        transform[1,2] = -sin_ang
        transform[2,1] = sin_ang
    else
        throw(ArgumentError("rotation underspecified!"))
    end

    Transform{n, Float64}(transform)
end

function translate(vect::Vector)
    n = length(vect)
    N = n + 1
    transform = MMatrix{N,N}(1.0*I)
    transform[1:n, N] = vect
    Transform{N, Float64}(SMatrix{N,N}(transform))
end

function translate(vect::SVector)
    n = length(vect)
    N = n + 1
    transform = MMatrix{N,N}(1.0*I)
    for i = 1:n
        transform[i, N] = vect[i]
    end
    Transform{N, Float64}(SMatrix{N,N}(transform))
end

function *(transform::Transform{N1,Float64}, obj::AbstractPrimitive{N2,T}) where {N1,N2,T}
    obj.transform = obj.transform*transform.transform
    obj.inv_transform = inv(obj.transform)
    obj
end

"""
Apply a homogenous tranform matrix to the points x, y, z
"""
function transform(it::Array{T,2}, _x, _y, _z) where {T}
    @inbounds x = _x*it[1,1]+_y*it[1,2]+_z*it[1,3]+it[1,4]
    @inbounds y = _x*it[2,1]+_y*it[2,2]+_z*it[2,3]+it[2,4]
    @inbounds z = _x*it[3,1]+_y*it[3,2]+_z*it[3,3]+it[3,4]
    x, y, z
end

function transform(it::Array{T,2}, x::Vector) where {T}
    transform(it, x...)
end

function transform(it::Array{T,2}, x::Point) where {T}
    transform(it, x...)
end

function transform(t::SMatrix, h::HyperRectangle)
    p_1 = t*SVector(h.origin... , 1)
    p_2 = t*SVector(h.widths... , 1)
    p_3 = t*SVector(h.origin[1]+h.widths[1],h.origin[2],h.origin[3], 1)
    p_4 = t*SVector(h.origin[1],h.origin[2]+h.widths[2],h.origin[3], 1)
    p_5 = t*SVector(h.origin[1],h.origin[2],h.origin[3]+h.widths[3], 1)
    p_6 = t*SVector(h.origin[1]+h.widths[1],h.origin[2],h.origin[3]+h.widths[3], 1)
    p_7 = t*SVector(h.origin[1],h.origin[2]+h.widths[2],h.origin[3]+h.widths[3], 1)
    p_8 = t*SVector(h.origin[1]+h.widths[1],h.origin[2]+h.widths[2],h.origin[3], 1)
    x_o = min(p_1[1],p_2[1],p_3[1],p_4[1],p_5[1],p_6[1],p_7[1],p_8[1])
    y_o = min(p_1[2],p_2[2],p_3[2],p_4[2],p_5[2],p_6[2],p_7[2],p_8[2])
    z_o = min(p_1[3],p_2[3],p_3[3],p_4[3],p_5[3],p_6[3],p_7[3],p_8[3])
    x_w = max(p_1[1],p_2[1],p_3[1],p_4[1],p_5[1],p_6[1],p_7[1],p_8[1])
    y_w = max(p_1[2],p_2[2],p_3[2],p_4[2],p_5[2],p_6[2],p_7[2],p_8[2])
    z_w = max(p_1[3],p_2[3],p_3[3],p_4[3],p_5[3],p_6[3],p_7[3],p_8[3])
    HyperRectangle(x_o, y_o, z_o, x_w-x_o, y_w-y_o, z_w-z_o)
end


#function clarkcatmull!(n::Integer, pipe::Pipe{Float64})
#    length(pipe.points) < 3 && return
#    num_pts = length(pipe.points)
#    num_new_pts = num_pts + num_pts*(2^n-1)
#
#    for _ = 1:n
#        i = 1
#        while i < length(p.points)
#            e1 = pipe.points[i]
#            e2 = pipe.points[i+1]
#            e3 = pipe.points[i+2]
#            fp1 = e1 + (e2-e1)/2
#            fp2 = e2 + (e3-e2)/2
#        end
#    end
#end
