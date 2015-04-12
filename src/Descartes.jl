module Descartes

#using Meshes

include("primitives.jl")
include("transforms.jl")
include("csg.jl")
include("frep.jl")

# primitives
export Cuboid, Cylinder, Sphere

# transforms
export Translation, translate

# CSG
export CSGUnion, CSGDiff, CSGIntersect

# frep
export FRep

end # module
