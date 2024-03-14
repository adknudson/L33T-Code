function squaresum_minus_sumsquare(n::Int)
    s = 0
    for i = 1:n, j = 1:n
        s += ifelse(i == j, 0, i*j)
    end
    return s
end

@time squaresum_minus_sumsquare(100)
