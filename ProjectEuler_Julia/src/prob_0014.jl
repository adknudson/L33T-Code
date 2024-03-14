function _collatz_steps(n, cache)
    haskey(cache, n) && return cache[n]

    n == 1 && return 0

    cache[n] = if iseven(n)
        1 + _collatz_steps(n ÷ 2, cache)
    else
        2 + _collatz_steps((3n+1) ÷ 2, cache)
    end

    return cache[n]
end

struct Collatz
    cache::Dict{Int, Int}
    Collatz() = new(Dict{Int,Int}())
end

(C::Collatz)(n) = _collatz_steps(n, C.cache)

const collatz_steps = Collatz()

function longest_seq(n)
    k, l = 0, 0
    for i in 1:n-1
        cl = collatz_steps(i)
        if cl > l
            k = i
            l = cl
        end
    end
    return (k,l)
end

@time longest_seq(10_000_000)
