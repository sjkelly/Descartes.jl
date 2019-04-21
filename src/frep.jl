# http://en.wikipedia.org/wiki/Function_representation

function _radius(a,b,r)
    if abs(a-b) >= r
        return min(a,b)
    else
        return b+r*sin(pi/4+asin((a-b)/(r*sqrt(2))))-r
    end
end

function FRep(p::Sphere, _x, _y, _z)
    it = p.inv_transform
    x = _x*it[1,1]+_y*it[1,2]+_z*it[1,3]+it[1,4]
    y = _x*it[2,1]+_y*it[2,2]+_z*it[2,3]+it[2,4]
    z = _x*it[3,1]+_y*it[3,2]+_z*it[3,3]+it[3,4]
    sqrt(x*x + y*y + z*z) - p.radius
end

function FRep(p::Cylinder, _x, _y, _z)
    it = p.inv_transform
    x = _x*it[1,1]+_y*it[1,2]+_z*it[1,3]+it[1,4]
    y = _x*it[2,1]+_y*it[2,2]+_z*it[2,3]+it[2,4]
    z = _x*it[3,1]+_y*it[3,2]+_z*it[3,3]+it[3,4]
    max(max(-z+p.bottom,z-p.height-p.bottom), sqrt(x*x + y*y) - p.radius)
end

function FRep(p::Cuboid, _x, _y, _z)
    it = p.inv_transform
    x = _x*it[1,1]+_y*it[1,2]+_z*it[1,3]+it[1,4]
    y = _x*it[2,1]+_y*it[2,2]+_z*it[2,3]+it[2,4]
    z = _x*it[3,1]+_y*it[3,2]+_z*it[3,3]+it[3,4]
    dx, dy, dz = p.dimensions
    lbx, lby,lbz = p.lowercorner
    max(max(-x+lbx, x-dx-lbx),
        max(-y+lby, y-dy-lby),
        max(-z+lbz, z-dz-lbz))
end

function FRep(u::CSGUnion, x, y, z)
    min(FRep(u.left, x,y,z),FRep(u.right, x,y,z))
end

function FRep(u::CSGDiff, x, y, z)
    max(FRep(u.left, x,y,z), -FRep(u.right, x,y,z))
end

function FRep(u::CSGIntersect, x, y, z)
    max(FRep(u.left, x,y,z), FRep(u.right, x,y,z))
end

function FRep(s::Shell, x, y, z)
    r = FRep(s.primitive, x, y, z)
    max(r, -r-s.distance)
end

function FRep(u::RadiusedCSGUnion, x, y, z)
    a = FRep(u.left, x,y,z)
    b = FRep(u.right, x,y,z)
    r = u.radius
    _radius(a,b,r)
end

function FRep(p::Piping{T}, x, y, z) where {T}
    num_pts = length(p.points)
    pt = Point(x,y,z)

    val = typemax(T)

    for i = 1:num_pts-1
        e1 = p.points[i]
        e2 = p.points[i+1]
        v = e2 - e1
        w = pt - e1
        if dot(w,v) <= 0
            nv = norm(pt - e1)
        elseif dot(v,v) <= dot(w,v)
            nv = norm(pt - e2)
        else
            nv = norm(cross(pt-e1,pt-e2))/norm(e2-e1)
        end
        val = min(nv, val)
    end
    val - p.radius
end
