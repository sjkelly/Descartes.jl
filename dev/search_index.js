var documenterSearchIndex = {"docs":
[{"location":"design/#Design-Overview-1","page":"Design","title":"Design Overview","text":"","category":"section"},{"location":"design/#","page":"Design","title":"Design","text":"Descartes current uses implicit modeling to create solid models. This is a brief overview of the system internals.","category":"page"},{"location":"design/#Implicit-Geometry-Pipeline-1","page":"Design","title":"Implicit Geometry Pipeline","text":"","category":"section"},{"location":"design/#UX-1","page":"Design","title":"UX","text":"","category":"section"},{"location":"design/#","page":"Design","title":"Design","text":"The UX (API) is designed to be familiar to those who use OpenSCAD. Let's start with a simple example to show the similarities.","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"This can all be executed in the Julia REPL, so follow along:","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"using Descartes\n\nc = Cuboid([5,5,5])\n\nh = translate([2.5,2.5,0])Cylinder(1,5)\n\nobj = diff(c,h)\n\nm = HomogenousMesh(obj)\n\nsave(\"cube_with_hole.stl\", m)","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"This first line:","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"using Descartes","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"This imports the Descartes library.","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"c = Cuboid([5,5,5])","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"Here we construct a cube of size 5x5x5.","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"h = translate([2.5,2.5,0])Cylinder(1,5)","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"This line shows the OpenSCADisms. This can be read right-to-left like a matrix operation. First we construct a cylinder of radius 1, and height 5. Next we translate the cylinder to the coordinates 2.5, 2.5, 0 to put it in the center of our cube.","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"obj = diff(c,h)","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"Here we difference the cylinder from the cube. The corresponding set operations are union and intersect.","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"m = HomogenousMesh(obj)","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"At this point we convert our object to a mesh. Prior to this point the model is simply a data structure. In the next section we will discuss the process of meshign more in-depth.","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"save(\"cube_with_hole.stl\", m)","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"Finally we save the mesh as an STL. Other formats such as OBJ, PLY, and OFF are also supported.","category":"page"},{"location":"design/#Meshing-1","page":"Design","title":"Meshing","text":"","category":"section"},{"location":"design/#","page":"Design","title":"Design","text":"In the prior section we mentioned that the \"model\" we create is just a data structure until we mesh it. So let's explore what happens in the meshing process.","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"The code to convert our data structure to a mesh is actually fairly short:","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"Current version","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"function (::Type{MT})(primitives::AbstractPrimitive{3, T}...;\n                                         samples=(128,128,128),\n                                         algorithm=MarchingCubes()\n                                         ) where {T, MT <: AbstractMesh}\n\n    f(x) = FRep(primitives[1], x)\n    mesh = MT(f, HyperRectangle(primitives[1]), samples, algorithm)\n\n    for i = 2:length(primitives)\n        b = HyperRectangle(primitives[i])\n        lm = MT(x -> FRep(primitives[i], x), b, samples, algorithm)\n        mesh = merge(mesh, lm)\n    end\n\n    return mesh\nend","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"The first two lines here are where the meshing happens:","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"    f(x) = FRep(primitives[1], x)\n    mesh = MT(f, HyperRectangle(primitives[1]), samples, algorithm)","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"Any primitve or operation must implement two core operations; FRep and HyperRectangle.","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"FRep is the functional representation (implicit representation) of the model. The first argument to FRep is always the primitive. The second is a generic AbstractVector. In julia we have type inference, so we do not need to annotate, so this will always be fast. FRep by convention must use 0 as the surface of the model, positive outside the model, and negative inside.","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"HyperRectangle should return the extents of the primitive. The underlying API will handle transformations and basic set operations for us.","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"In the next line we actually perform the meshing operation. We call the meshtype with the implicit function we created, f, in the bounds generated by HyperRectangle, uniformly sample the space by samples, and actually generate the triangular meshing using algorithm. In this case, the defaults are samples=(128,128,128) and algorithm=MarchingCubes().","category":"page"},{"location":"design/#","page":"Design","title":"Design","text":"In the loop for i = 2:length(primitives) ... end we handle additional primitives passed to our meshing function so you can create a single mesh output from several different objects. In order to maintain performance and resolution these are not unioned.","category":"page"},{"location":"#Descartes.jl-1","page":"Descartes.jl","title":"Descartes.jl","text":"","category":"section"},{"location":"#","page":"Descartes.jl","title":"Descartes.jl","text":"Descartes is a research project into the representation of solid geometry. It is designed to leverage Julia's multiple dispatch and JIT compilation to create a platform which unifies otherwise disparate geometric representations. The long term goal is to deliver a geometry kernel suited for the growing capabilities of digital manufacturing.","category":"page"},{"location":"#","page":"Descartes.jl","title":"Descartes.jl","text":"The current focus is on the development of feature parity with OpenSCAD and enhanced design with engineering analysis. Under the hood Descartes uses a functional representation of geometry, inspired by ImplicitCAD, HyperFun, libfive, and several others. The syntax is idiomatic julia, but should be familiar to those used to OpenSCAD.","category":"page"},{"location":"#","page":"Descartes.jl","title":"Descartes.jl","text":"Examples","category":"page"},{"location":"#","page":"Descartes.jl","title":"Descartes.jl","text":"There are occasional development updates posted here.","category":"page"}]
}