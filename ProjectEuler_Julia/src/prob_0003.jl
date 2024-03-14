function generate_primes(n::Int)
    ps = collect(2:n)
    bs = BitVector(fill(true, length(ps)))

    sqrtn = sqrt(n)

    i = 2
    while i <= sqrtn
        if bs[i-1] == true
            j = i^2
            while j <= n
                bs[j-1] = false
                j += i
            end
        end
        i += 1
    end

    return ps[bs]
end

function largest_prime_factor(k::Int)
    n = round(Int, sqrt(k), RoundUp)
    primes = generate_primes(n)

    ps = Int[]

    while k != 1
        for p in primes
            k % p != 0 && continue
            push!(ps, p)
            k = k ÷ p
            break
        end
    end

    return maximum(ps)
end

largest_prime_factor(600851475143)


# Solution Using Primes.jl
using Primes
factor(Vector, 600851475143) |> maximum
