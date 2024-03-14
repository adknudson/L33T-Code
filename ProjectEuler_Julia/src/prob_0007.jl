using Transducers

function is_prime(n::T) where {T<:Integer}
    n == 1 && return false
    n == 2 && return true
    for d = 2:ceil(T, sqrt(n))
        n % d == 0 && return false
    end

    return true
end

function nth_prime(n::Integer)
    Iterators.countfrom(1) |>
        Filter(is_prime) |>
        Take(n) |>
        TakeLast(1) |>
        only
end

@time nth_prime(10_001)


# Solution using Primes.jl
using Primes
@time prime(10_001)
