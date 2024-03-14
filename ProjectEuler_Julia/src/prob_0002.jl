using Transducers

function _fib(n, cache::Dict{K,V}) where {K,V}
    n == 0 && return zero(V)
    n == 1 && return one(V)
    n == 2 && return one(V) * 2

    haskey(cache, n) && return cache[n]

    f = _fib(n - 1, cache) + _fib(n - 2, cache)
    cache[n] = f
    return f
end

struct Fib{K,V}
    cache::Dict{K, V}
    Fib{K,V}() where {K,V} = new{K,V}(Dict{K,V}())
end

(f::Fib{K,V})(n::K) where {K,V} = _fib(n, f.cache)

const _fibInt = Fib{Int,Int}()
const _fibBigInt = Fib{BigInt, BigInt}()

fib(n::Integer) = _fibInt(n)
fib(n::Int) = _fibInt(n)
fib(n::BigInt) = _fibBigInt(n)

function sum_even_less_than(n::Integer)
    Iterators.countfrom(one(n)) |>
        Map(fib) |>
        Filter(iseven) |>
        TakeWhile(<(n)) |>
        sum
end

@time sum_even_less_than(4_000_000)
@time sum_even_less_than(4_000_000)
