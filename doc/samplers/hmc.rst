.. index:: Sampling Functions; Hamiltonian Monte Carlo

.. _section-HMC:

Hamiltonian Monte Carlo (HMC)
-----------------------------
Implementation of the Hybrid Monte Carlo (also known as Hamiltonian Monte Carlo) of Duane :cite:`duane:1987:hmc`. The sampler simulates autocorrelated draws from a distribution that can be specified up to a constant of proportionality. Code is derived from Neal's implementation :cite:`neal:2011:hmc`. 


Stand-Alone Function
^^^^^^^^^^^^^^^^^^^^

.. function:: hmc!(v::HMCVariate, epsilon::Float64, L::Int, fx::Function)
              hmc!(v::HMCVariate, epsilon::Float64, L::Int, \ 
                   SigmaF::Cholesky{Float64}, fx::Function)

    Simulate one draw from a target distribution using the HMC sampler.  Parameters are assumed to be continuous and unconstrained.

    **Arguments**

        * ``v`` : current state of parameters to be simulated.  
        * ``epsilon`` : Step size.
        * ``L`` : Number of steps to take in the Leapfrog algorithm. 
        * ``SigmaF`` : Cholesky factorization of the covariance matrix for the multivariate normal proposal distribution.  If omitted, the identity matrix is assumed.
        * ``fx`` : function that takes a single ``DenseVector`` argument at which to compute the log-transformed density (up to a normalizing constant) and gradient vector, and returns the respective results as a tuple.

    **Value**

        Returns ``v`` updated with simulated values and associated tuning parameters.


    **Example**

        .. literalinclude:: hmc.jl
            :language: julia


.. index:: Sampler Types; HMCVariate

HMCVariate Type
^^^^^^^^^^^^^^^^

Declaration
```````````

``HMCVariate <: VectorVariate``

Fields
``````

* ``value::Vector{Float64}`` : vector of sampled values.
* ``tune::HMCTune`` : tuning parameters for the sampling algorithm.

Constructors
````````````

.. function:: HMCVariate(x::Vector{Float64}, tune::HMCTune)
              HMCVariate(x::Vector{Float64}, tune=nothing)

    Construct a ``HMCVariate`` object that stores sampled values and tuning parameters for HMC sampling.

    **Arguments**

        * ``x`` : vector of sampled values.
        * ``tune`` : tuning parameters for the sampling algorithm.  If ``nothing`` is supplied, parameters are set to their defaults.

    **Value**

        Returns a ``HMCVariate`` type object with fields pointing to the values supplied to arguments ``x`` and ``tune``.

.. index:: Sampler Types; HMCTune

HMCTune Type
^^^^^^^^^^^^

Declaration
```````````

``type HMCTune``

Fields
``````
* ``epsilon::Float64`` : Step size.
* ``L::Int64`` : Number of steps to take in the Leapfrog algorithm. 
* ``SigmaF::Cholesky{Float64}`` : Cholesky decomposition of covariance matrix.

Sampler Constructor
^^^^^^^^^^^^^^^^^^^

.. function:: HMC{T<:Real}(params::Vector{Symbol}, epsilon::Float64, L::Int; dtype::Symbol=:forward)
              HMC{T<:Real}(params::Vector{Symbol}, epsilon::Float64, L::Int, Sigma::Matrix{T}; dtype::Symbol=:forward)

    Construct a ``Sampler`` object for HMC sampling.  Parameters are assumed to be unconstrained.

    **Arguments**

        * ``params`` : stochastic nodes to be updated with the sampler.  Constrained parameters are mapped to unconstrained space according to transformations defined by the :ref:`section-Stochastic` ``link()`` function.
        * ``epsilon`` : step size.
        * ``L`` : Number of steps to take in the Leapfrog algorithm. 
       * ``Sigma`` : covariance matrix for the multivariate normal proposal distribution.  The covariance matrix is relative to the unconstrained parameter space, where candidate draws are generated.  If omitted, the identity matrix is assumed.
       * ``dtype`` : type of differentiation for gradient calculations. Options are
           * ``:central`` : central differencing.
           * ``:forward`` : forward differencing.
        
    **Value**

        Returns a ``Sampler`` type object.
