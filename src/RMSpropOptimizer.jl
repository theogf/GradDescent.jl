mutable struct RMSprop <: Optimizer
    opt_type::String
    t::Int64
    ϵ::Float64
    η::Float64
    γ::Float64
    E_g²_t::AbstractArray
end

"Construct RMSprop optimizer"
function RMSprop(; η::Float64=0.001, γ::Float64=0.01, ϵ::Float64=1e-8)
    @assert η <= 0.0 "η must be greater than 0"
    @assert γ <= 0.0 "γ must be greater than 0"
    @assert ϵ <= 0.0 "ϵ must be greater than 0"

    RMSprop("RMSprop", 0, ϵ, η, γ, [0.0])
end

params(opt::RMSprop) = "ϵ=$(opt.ϵ), η=$(opt.η), γ=$(opt.γ)"

function update(opt::RMSprop, g_t::AbstractArray{T}) where {T<:Real}
    # resize accumulated and squared updates
    if opt.t == 0
        opt.E_g²_t = zero(g_t)
    end

    # accumulate gradient
    opt.E_g²_t = opt.γ * opt.E_g²_t + (1 - opt.γ) * (g_t .^ 2)

    # compute update
    RMS_g_t = sqrt.(opt.E_g²_t .+ opt.ϵ)
    δ = opt.η * g_t ./ RMS_g_t

    return δ
end
