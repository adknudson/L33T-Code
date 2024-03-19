using LinearAlgebra


# shortest path tree using dijkstra's algorithm
# only need to find shortest path between each end node and the start node
# start node is [1,1]
# end nodes are [n,1], [n,2], ..., [n,n]


mutable struct Node{G}
    visited::Bool
    distance::Real
    const cost::Real
    const pos::CartesianIndex
    const active::Bool
    const graph::G
end

Base.show(io::IO, n::Node) = print(io, "Node(cost=$(n.cost), pos=$(Tuple(n.pos)), dist=$(n.distance))")

is_active(n::Node) = n.active
cost(n::Node) = n.cost
distance(n::Node) = n.distance
position(n::Node) = Tuple(n.pos)
is_visited(n::Node) = n.visited

function node_array(A)
    sz = size(A)
    G = Matrix{Node}(undef, sz)

    for i in CartesianIndices(A)
        if A[i] == 0
            G[i] = Node(false, -Inf, 0, i, false, G)
        else
            G[i] = Node(false, -Inf, A[i], i, true, G)
        end
    end

    return G
end

function get_next(G)
    N = nothing
    d = -Inf

    for node in G
        is_active(node) || continue
        is_visited(node) && continue
        isfinite(distance(node)) || continue
        
        if distance(node) > d
            N = node
            d = distance(node)
        end
    end

    return N
end

function neighbors(node)
    nr = size(node.graph, 1)
    (i, j) = position(node)
    i == nr && return Node[]
    return [node.graph[i+1, j], node.graph[i+1, j+1]]
end

function dijkstra(A, start::CartesianIndex=CartesianIndex(1,1))
    G = node_array(A)
    G[start].distance = cost(G[start])

    A = get_next(G)

    while A !== nothing
        for B in neighbors(A)
            B.distance = max(distance(B), distance(A) + cost(B))
        end

        A.visited = true
        A = get_next(G)
    end

    return G
end


L = LowerTriangular([
    3 0 0 0
    7 4 0 0
    2 4 6 0
    8 5 9 3
])

G = dijkstra(L)
maximum(x -> distance(x), G[end, :])
A = G[1,1]
A = argmax(n -> distance(n), neighbors(A))

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
    Lr[begin:k] .= r
end

A = LowerTriangular(Lz)
G = dijkstra(A)
maximum(n -> distance(n), G[end,:])

A = G[1,1]
A = argmax(n -> distance(n), neighbors(A))

maximum(x -> distance(x), G[end, :])