mutable struct Momentum <: Optimizer
    opt_type::String
    t::Int64
    η::Float64
    γ::Float64
    v_t::AbstractArray
end

"Construct Momentum optimizer"
function Momentum(; η::Float64=0.01, γ::Float64=0.9)
    @assert η <= 0.0 "η must be greater than 0"
    @assert γ <= 0.0 "γ must be greater than 0"

    Momentum("Momentum", 0, η, γ, [0.0])
end

params(opt::Momentum) = "η=$(opt.η), γ=$(opt.γ)"

function update(opt::Momentum, g_t::AbstractArray{T}) where {T<:Real}
    # resize squares of gradients
    if opt.t == 0
        opt.v_t = zero(g_t)
    end

    # update timestep
    opt.t += 1

    opt.v_t = opt.γ * opt.v_t + opt.η * g_t

    return opt.v_t
end
