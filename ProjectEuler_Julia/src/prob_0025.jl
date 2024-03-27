using Chairmarks

function fib_ndigits(k=3)
    a, b = big(1), big(1)
    i = 1
    while ndigits(a) < k
        a, b = b, a + b
        i += 1
    end
    return i, a
end

@be fib_ndigits(1000)
