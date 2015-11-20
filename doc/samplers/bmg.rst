.. index:: Sampling Functions; Binary Metropolised Gibbs

.. _section-BMG:

Binary Metropolised Gibbs (BMG)
-------------------------------

Implementation of a binary-state Metropolised Gibbs sampler in which components are drawn sequentially from full conditional marginal distributions and accepted together in a single Metropolis-Hastings step.  The sampler simulates autocorrelated draws from a distribution that can be specified up to a constant of proportionality.


Stand-Alone Function
^^^^^^^^^^^^^^^^^^^^

.. function:: bmg!(v::BMGVariate, logf::Function)

    Simulate one draw from a target distribution using the BMG sampler.  Parameters are assumed to have binary numerical values (0 or 1).

    **Arguments**

        * ``v`` : current state of parameters to be simulated.
        * ``logf`` : function that takes a single ``DenseVector`` argument of parameter values at which to compute the log-transformed density (up to a normalizing constant).

    **Value**

        Returns ``v`` updated with simulated values and associated tuning parameters.

    .. _example-bmg:

    **Example**

        .. literalinclude:: bmg.jl
            :language: julia


.. index:: Sampler Types; BMGVariate

BMGVariate Type
^^^^^^^^^^^^^^^^

Declaration
```````````

``BMGVariate <: VectorVariate``

Fields
``````

* ``value::Vector{Float64}`` : vector of sampled values.
* ``tune::BMGTune`` : tuning parameters for the sampling algorithm.

Constructors
````````````

.. function:: BMGVariate(x::AbstractVector{T<:Real}, tune::BMGTune)
              BMGVariate(x::AbstractVector{T<:Real}, tune=nothing)

    Construct a ``BMGVariate`` object that stores sampled values and tuning parameters for BMG sampling.

    **Arguments**

        * ``x`` : vector of sampled values.
        * ``tune`` : tuning parameters for the sampling algorithm.  If ``nothing`` is supplied, parameters are set to their defaults.

    **Value**

        Returns a ``BMGVariate`` type object with fields pointing to the values supplied to arguments ``x`` and ``tune``.

BMGTune Type
^^^^^^^^^^^^^

Declaration
```````````

``type BMGTune``

Fields
``````

* ``probs::Vector{Float64}`` : probabilities of the full conditional marginal distributions from which components of the candidate vector were sequentially drawn.


Sampler Constructor
^^^^^^^^^^^^^^^^^^^

.. function:: BMG(params::Vector{Symbol})

    Construct a ``Sampler`` object for BMG sampling.  Parameters are assumed to have binary numerical values (0 or 1).

    **Arguments**

        * ``params`` : stochastic nodes containing the parameters to be updated with the sampler.

    **Value**

        Returns a ``Sampler`` type object.

    **Example**

        See the :ref:`Pollution <example-Pollution>` and other :ref:`section-Examples`.
