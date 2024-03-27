function lexicographic_order(xs, k::Int)
    ys = Int[]
    n = length(xs)
    s = 0

    while !isempty(xs)
        i = 1
        f = factorial(n - 1)
        while s + f * i < k
            i += 1
        end
        s += f * (i - 1)
        push!(ys, popat!(xs, i))
        n -= 1
    end

    return join(ys)
end

function lexicographic_order(xs, k::BigInt)
    ys = Int[]
    n = length(xs)
    s = zero(BigInt)

    while !isempty(xs)
        i = 1
        f = factorial(big(n-1))
        while s + f * i < k
            i += 1
        end
        s += f * (i - 1)
        push!(ys, popat!(xs, i))
        n -= 1
    end

    return join(ys)
end


using Chairmarks

@b lexicographic_order(collect(0:9), 1_000_000)
@b lexicographic_order(collect(0:4999), big"26896443365364334653654780462450076648921005804311233455575623454532")
