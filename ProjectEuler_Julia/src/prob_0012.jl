using Transducers
using Primes

function f(n)
    i = 1
    k = 0
    while true
        k += i
        (length ∘ divisors)(k) > n && return k
        i += 1
    end
end

triangle_sum(n) = n * (n + 1) ÷ 2

function g(n)
    Iterators.countfrom(1) |>
        Scan(+, 0) |>
        Filter(x -> (length ∘ divisors)(x) > n) |>
        Take(1) |>
        only
end


@time f(500)
@time g(500)
