module Day01

function read_input(io)
    x = Vector{Int}()
    y = Vector{Int}()

    for line in eachline(io)
        l, r = parse.(Int, split(line))
        push!(x, l)
        push!(y, r)
    end

    return (x, y)
end

sum_abs_diff(x,y) = sum(abs, x .- y)

function similarity_score(x, y)
    s = 0

    for a in x
        s += a * count(==(a), y)
    end

    return s
end

end

using .Day01

using Test

ex = """
3   4
4   3
2   5
1   3
3   9
3   3
"""

x, y = Day01.read_input(IOBuffer(ex))

sort!(x)
sort!(y)

d = Day01.sum_abs_diff(x, y)
s = Day01.similarity_score(x, y)

@test x == [1, 2, 3, 3, 3, 4]
@test y == [3, 3, 3, 4, 5, 9]
@test d == 11
@test s == 31

data = "../data/01.txt"

x, y = open("./data/01.txt") do io
    x, y = Day01.read_input(io)
    sort!(x)
    sort!(y)
    (x, y)
end

d = Day01.sum_abs_diff(x, y)
s = Day01.similarity_score(x, y)
