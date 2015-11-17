.. index:: Sampling Functions; Binary MCMC Model Composition

.. _section-BMC3:

Binary MCMC Model Composition (BMC3)
-----------------------------------------

Implementation of the binary-state MCMC Model Composition of Madigan and York :cite:`madigan:1995:MC3` in which proposed updates are always state changes.  The sampler simulates autocorrelated draws from a distribution that can be specified up to a constant of proportionality.


Stand-Alone Function
^^^^^^^^^^^^^^^^^^^^

.. function:: bmc3!(v::BMC3Variate, indexset::Vector{Vector{Int}}, logf::Function)

    Simulate one draw from a target distribution using the BMC3 sampler.  Parameters are assumed to have binary numerical values (0 or 1).

    **Arguments**

        * ``v`` : current state of parameters to be simulated.
        * ``indexset`` : candidate set of indices of the parameters whose states are to be changed simultaneously.
        * ``logf`` : function that takes a single ``DenseVector`` argument of parameter values at which to compute the log-transformed density (up to a normalizing constant).

    **Value**

        Returns ``v`` updated with simulated values and associated tuning parameters.

    .. _example-bmc3:

    **Example**

        .. literalinclude:: bmc3.jl
            :language: julia


.. index:: Sampler Types; BMC3Variate

BMC3Variate Type
^^^^^^^^^^^^^^^^

Declaration
```````````

``BMC3Variate <: VectorVariate``

Fields
``````

* ``value::Vector{Float64}`` : vector of sampled values.
* ``tune::BMC3Tune`` : tuning parameters for the sampling algorithm.

Constructors
````````````

.. function:: BMC3Variate(x::Vector{Float64}, tune::BMC3Tune)
              BMC3Variate(x::Vector{Float64}, tune=nothing)

    Construct a ``BMC3Variate`` object that stores sampled values and tuning parameters for BMC3 sampling.

    **Arguments**

        * ``x`` : vector of sampled values.
        * ``tune`` : tuning parameters for the sampling algorithm.  If ``nothing`` is supplied, parameters are set to their defaults.

    **Value**

        Returns a ``BMC3Variate`` type object with fields pointing to the values supplied to arguments ``x`` and ``tune``.

.. index:: Sampler Types; BMC3Tune

BMC3Tune Type
^^^^^^^^^^^^^

Declaration
```````````

``type BMC3Tune``

Fields
``````

* ``indexset::Vector{Vector{Int}}`` : candidate set of indices of the parameters whose states are to be changed simultaneously.


Sampler Constructor
^^^^^^^^^^^^^^^^^^^

.. function:: BMC3(params::Vector{Symbol}, d::Integer, k::Integer=1)
              BMC3(params::Vector{Symbol}, indexset::Vector{Vector{Int}})

    Construct a ``Sampler`` object for BMC3 sampling.  Parameters are assumed to have binary numerical values (0 or 1).

    **Arguments**

        * ``params`` : stochastic nodes containing the parameters to be updated with the sampler.
        * ``d`` : total length of the parameters in the combined nodes.
        * ``k`` : generate all combinations of ``k <= d`` candidate indices of the parameters to change.
        * ``indexset`` : candidate set of indices of the parameters to change.

    **Value**

        Returns a ``Sampler`` type object.
