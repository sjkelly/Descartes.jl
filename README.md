# Descartes

[![Build Status](https://travis-ci.org/sjkelly/Descartes.jl.svg?branch=master)](https://travis-ci.org/sjkelly/Descartes.jl)
[![Coverage Status](https://coveralls.io/repos/github/sjkelly/Descartes.jl/badge.svg?branch=master)](https://coveralls.io/github/sjkelly/Descartes.jl?branch=master)

Descartes is a research project into the representation of solid geometry. It
is designed to leverage Julia's multiple dispatch and JIT compilation to
create a platform which unifies otherwise disparate geometric representations.
The long term goal is to deliver a geometry kernel suited for the growing
capabilities of digital manufacturing.

We aim to support the following representations cohesively:

- [BRep](http://en.wikipedia.org/wiki/Boundary_representation)
- [Functional](http://en.wikipedia.org/wiki/Function_representation)
- [CSG](http://en.wikipedia.org/wiki/Constructive_solid_geometry)
- [Analytic CSG](http://en.wikipedia.org/wiki/Rvachev_function)

## License
This package is available under the MIT "Expat" License. See [LICENSE.md](./LICENSE.md).
