using Transducers, Primes

function factor_union!(l::Primes.Factorization, r::Primes.Factorization)
    for k in union(keys(l), keys(r))
        l[k] = max(l[k], r[k])
    end
    return l
end

function smallest_multiple(n::T) where {T<:Integer}
    foldl(factor_union!, one(T):n |> Map(factor), init=factor(one(T))) |> prod
end

@time smallest_multiple(big(20))


# Solution using builtin `lcm`
lcm(1:20)

@time lcm(big(1):50_000);
