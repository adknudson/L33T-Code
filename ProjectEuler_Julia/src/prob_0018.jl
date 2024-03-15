using LinearAlgebra


# shortest path tree using dijkstra's algorithm
# only need to find shortest path between each end node and the start node
# start node is [1,1]
# end nodes are [n,1], [n,2], ..., [n,n]


function dijkstra(A, start::CartesianIndex, stop::CartesianIndex)

end


L = LowerTriangular([
    3 0 0 0
    7 4 0 0
    2 4 6 0
    8 5 9 3
])

steps = descend(L, greedy)
[L[step...] for step in steps]

L = [
    vec([75]),
    vec([95 64]),
    vec([17 47 82]),
    vec([18 35 87 10]),
    vec([20 04 82 47 65]),
    vec([19 01 23 75 03 34]),
    vec([88 02 77 73 07 63 67]),
    vec([99 65 04 28 06 16 70 92]),
    vec([41 41 26 56 83 40 80 70 33]),
    vec([41 48 72 33 47 32 37 16 94 29]),
    vec([53 71 44 65 25 43 91 52 97 51 14]),
    vec([70 11 33 28 77 73 17 78 39 68 17 57]),
    vec([91 71 52 38 17 14 91 43 58 50 27 29 48]),
    vec([63 66 04 68 89 53 67 30 73 16 69 87 40 31]),
    vec([04 62 98 27 23 09 70 98 73 93 38 53 60 04 23]),
]

n = length(L)
Lz = zeros(Int, n, n)

for (r, Lr) in zip(L, eachrow(Lz))
    k = length(r)
    Lr[1:k] .= r
end

A = LowerTriangular(Lz)
steps = descend(A, greedy)
vs = [A[step...] for step in steps]
sum(vs)
