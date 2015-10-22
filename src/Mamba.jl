using Distributions

module Mamba

  using Distributions
  using Gadfly


  #################### Imports ####################

  import Base: cor, dot
  import Base.LinAlg: Cholesky
  import Calculus: gradient
  import Compose: Context, context, cm, gridstack, inch, MeasureOrNumber, mm,
         pt, px
  import Distributions:
         ## Generic Types
         Continuous, ContinuousUnivariateDistribution, Distribution,
         MatrixDistribution, MultivariateDistribution, PDiagMat, PDMat, ScalMat,
         Truncated, UnivariateDistribution, ValueSupport,
         ## ContinuousUnivariateDistribution Types
         Arcsine, Beta, BetaPrime, Biweight, Cauchy, Chi, Chisq, Cosine,
         Epanechnikov, Erlang, Exponential, FDist, Frechet, Gamma, Gumbel,
         InverseGamma, InverseGaussian, Kolmogorov, KSDist, KSOneSided, Laplace,
         Levy, Logistic, LogNormal, NoncentralBeta, NoncentralChisq,
         NoncentralF, NoncentralT, Normal, NormalCanon, Pareto, Rayleigh,
         SymTriangularDist, TDist, TriangularDist, Triweight, Uniform, VonMises,
         Weibull,
         ## DiscreteUnivariateDistribution Types
         Bernoulli, Binomial, Categorical, DiscreteUniform, Geometric,
         Hypergeometric, NegativeBinomial, Pareto, PoissonBinomial, Skellam,
         ## MultivariateDistribution Types
         Dirichlet, Multinomial, MvNormal, MvNormalCanon, MvTDist, VonMisesFisher,
         ## MatrixDistribution Types
         InverseWishart, Wishart,
         ## Methods
         gradlogpdf, insupport, isprobvec, logpdf, logpdf!, maximum, minimum,
         quantile, rand, support
  import Gadfly: draw, Geom, Guide, Layer, layer, PDF, PGF, Plot, plot, PNG, PS,
         render, Scale, SVG, Theme
  import Graphs: AbstractGraph, add_edge!, add_vertex!, Edge, KeyVertex, graph,
         out_edges, out_neighbors, target, topological_sort_by_dfs, vertices
  import Showoff: showoff
  import StatsBase: autocor, autocov, countmap, counts, describe, predict,
         quantile, sem, summarystats

  include("distributions/pdmats2.jl")
  importall .PDMats2


  #################### Variate Types ####################

  abstract ScalarVariate <: Real
  abstract ArrayVariate{N} <: DenseArray{Float64,N}

  typealias AbstractVariate Union{ScalarVariate, ArrayVariate}
  typealias VectorVariate ArrayVariate{1}
  typealias MatrixVariate ArrayVariate{2}


  #################### Distribution Types ####################

  typealias DistributionStruct Union{Distribution,
                                     Array{UnivariateDistribution},
                                     Array{MultivariateDistribution}}


  #################### Dependent Types ####################

  type ScalarLogical <: ScalarVariate
    value::Float64
    symbol::Symbol
    monitor::Vector{Int}
    eval::Function
    sources::Vector{Symbol}
    targets::Vector{Symbol}
  end

  type ArrayLogical{N} <: ArrayVariate{N}
    value::Array{Float64,N}
    symbol::Symbol
    monitor::Vector{Int}
    eval::Function
    sources::Vector{Symbol}
    targets::Vector{Symbol}
  end

  type ScalarStochastic <: ScalarVariate
    value::Float64
    symbol::Symbol
    monitor::Vector{Int}
    eval::Function
    sources::Vector{Symbol}
    targets::Vector{Symbol}
    distr::UnivariateDistribution
  end

  type ArrayStochastic{N} <: ArrayVariate{N}
    value::Array{Float64,N}
    symbol::Symbol
    monitor::Vector{Int}
    eval::Function
    sources::Vector{Symbol}
    targets::Vector{Symbol}
    distr::DistributionStruct
  end

  typealias AbstractLogical Union{ScalarLogical, ArrayLogical}
  typealias AbstractStochastic Union{ScalarStochastic, ArrayStochastic}
  typealias AbstractDependent Union{AbstractLogical, AbstractStochastic}


  #################### Sampler Type ####################

  type Sampler
    params::Vector{Symbol}
    eval::Function
    tune::Dict{AbstractString,Any}
    targets::Vector{Symbol}
  end


  #################### Model Type ####################

  type Model
    nodes::Dict{Symbol,Any}
    dependents::Vector{Symbol}
    samplers::Vector{Sampler}
    states::Vector{Vector{Float64}}
    iter::Int
    burnin::Int
    chain::Int
    hasinputs::Bool
    hasinits::Bool
  end


  #################### Chains Type ####################

  abstract AbstractChains

  immutable Chains <: AbstractChains
    value::Array{Float64,3}
    range::Range{Int}
    names::Vector{AbstractString}
    chains::Vector{Int}
  end

  immutable ModelChains <: AbstractChains
    value::Array{Float64,3}
    range::Range{Int}
    names::Vector{AbstractString}
    chains::Vector{Int}
    model::Model
  end


  #################### Includes ####################

  include("progress.jl")
  include("utils.jl")
  include("variate.jl")

  include("distributions/constructors.jl")
  include("distributions/distributionstruct.jl")
  include("distributions/flat.jl")
  include("distributions/mvnormal.jl")
  include("distributions/null.jl")
  include("distributions/pdmatdistribution.jl")
  include("distributions/transformdistribution.jl")

  include("model/core.jl")
  include("model/dependent.jl")
  include("model/graph.jl")
  include("model/initialization.jl")
  include("model/mcmc.jl")
  include("model/simulation.jl")

  include("output/chains.jl")
  include("output/chainsummary.jl")
  include("output/fileio.jl")
  include("output/gelmandiag.jl")
  include("output/gewekediag.jl")
  include("output/heideldiag.jl")
  include("output/mcse.jl")
  include("output/modelchains.jl")
  include("output/modelstats.jl")
  include("output/rafterydiag.jl")
  include("output/stats.jl")
  include("output/plot.jl")

  include("samplers/amm.jl")
  include("samplers/amwg.jl")
  include("samplers/bmmg.jl")
  include("samplers/dgs.jl")
  include("samplers/hmc.jl")
  include("samplers/miss.jl")
  include("samplers/nuts.jl")
  include("samplers/sampler.jl")
  include("samplers/slice.jl")
  include("samplers/slicesimplex.jl")


  #################### Exports ####################

  export
    AbstractChains,
    AbstractDependent,
    AbstractLogical,
    AbstractStochastic,
    AbstractVariate,
    ArrayLogical,
    ArrayStochastic,
    ArrayVariate,
    Chains,
    Logical,
    MatrixVariate,
    Model,
    ModelChains,
    Sampler,
    ScalarLogical,
    ScalarStochastic,
    ScalarVariate,
    Stochastic,
    VectorVariate

  export
    BDiagNormal,
    Flat

  export
    @modelexpr,
    autocor,
    changerate,
    cor,
    describe,
    dic,
    draw,
    gelmandiag,
    gewekediag,
    gradlogpdf,
    gradlogpdf!,
    graph,
    graph2dot,
    heideldiag,
    hpd,
    insupport,
    invlink,
    invlogit,
    link,
    logit,
    logpdf,
    logpdf!,
    mcmc,
    mcse,
    plot,
    predict,
    quantile,
    rafterydiag,
    rand,
    readcoda,
    relist,
    relist!,
    setinits!,
    setinputs!,
    setmonitor!,
    setsamplers!,
    simulate!,
    summarystats,
    tune,
    unlist,
    update!

  export
    amm!,
    AMM,
    AMMVariate,
    amwg!,
    AMWG,
    AMWGVariate,
    bmmg!,
    BMMG,
    BMMGVariate,
    dgs!,
    DGS,
    DGSVariate,
    hmc!,
    HMC,
    HMCVariate,
    MISS,
    nuts!,
    nutsepsilon,
    NUTS,
    NUTSVariate,
    slice!,
    Slice,
    SliceVariate,
    slicesimplex!,
    SliceSimplex,
    SliceSimplexVariate

  export
    cm,
    inch,
    mm,
    pt,
    px


  #################### Deprecated ####################

  include("deprecated.jl")

end
