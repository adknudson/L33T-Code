using Test
using Chairmarks

get_data(io) = reduce(hcat, parse.(Int, split(l)) for l in eachline(io))

function part1(xy)
    x = @view xy[1,:]
    y = @view xy[2,:]
    sort!(x)
    sort!(y)
    return sum(abs, x .- y)
end

function part2(xy)
    x = @view xy[1,:]
    y = @view xy[2,:]
    return sum(a -> a * count(==(a), y), x)
end

ex = """
3   4
4   3
2   5
1   3
3   9
3   3
"""

xy = get_data(IOBuffer(ex))
p1 = part1(xy)
p2 = part2(xy)
@test p1 == 11
@test p2 == 31

xy = open(get_data, "./data/01.txt")
@b part1(xy)
@b part2(xy)
