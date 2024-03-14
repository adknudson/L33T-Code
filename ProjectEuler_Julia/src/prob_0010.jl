using Transducers

function is_prime(n::T) where {T<:Integer}
    n == 1 && return false
    n == 2 && return true
    for d = 2:ceil(T, sqrt(n))
        n % d == 0 && return false
    end

    return true
end

sum_primes_up_to(n) = foldxt(+, 1:n |> Filter(is_prime))

@time sum_primes_up_to(2_000_000)



using Primes
sum_primes_up_to2(n) = sum(primes(2, n-1))
@time sum_primes_up_to2(2_000_000)
