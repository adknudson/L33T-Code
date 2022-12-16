using Graphs

function linearindex(grid, loc::CartesianIndex)
    m = size(grid, 1)
    i, j = loc.I
    return i + (j - 1) * m
end

function cartesianindex(grid, i::Int)
    a, b = divrem(i - 1, size(grid, 1)) .+ (1, 1)
    return CartesianIndex(b, a)
end

function isvalidstep(grid, loc::CartesianIndex, delta::CartesianIndex)
    row, col = loc.I
    dy, dx = delta.I
    
    manhattan_dist = abs(dy) + abs(dx)
    manhattan_dist == 1 || return false
    
    checkbounds(Bool, grid, row + dy, col + dx) || return false

    current_height = grid[loc]
    destination_height = grid[loc + delta]
    return destination_height - current_height <= 1
end

isvalidstep(grid, loc, dy, dx) = isvalidstep(grid, loc, CartesianIndex(dy, dx))

getstepoptions(grid, loc::CartesianIndex) = (CartesianIndex(dy, dx) for dx in -1:1 for dy in -1:1 if isvalidstep(grid, loc, dy, dx))
getstepoptions(grid, loc::CartesianIndex, visited::Set{CartesianIndex}) = (delta for delta in getstepoptions(grid, loc) if loc + delta ∉ visited)


function process_input(path::AbstractString)
    input = readlines(path)
    m = hcat([[s for s in line] for line in input]...)
    grid = permutedims(m)
    current = findfirst(==('S'), grid)
    destination = findfirst(==('E'), grid)
    grid[current] = 'a'
    grid[destination] = 'z'

    return grid, current, destination
end

function create_graph(grid)
    g = SimpleDiGraph()
    add_vertices!(g, length(grid))

    for loc in CartesianIndices(grid)
        for delta in getstepoptions(grid, loc)
            i = linearindex(grid, loc)
            j = linearindex(grid, loc + delta)
            add_edge!(g, i, j)
        end
    end

    return g
end


grid, start, dest = process_input("data/input12")
g = create_graph(grid)
s = linearindex(grid, start)
d = linearindex(grid, dest)

a_star(g, s, d)

paths = Vector{Vector{Graphs.SimpleGraphs.SimpleEdge{Int64}}}()
for i in eachindex(grid)
    grid[i] == 'a' || continue
    path = a_star(g, i, d)
    isempty(path) && continue
    push!(paths, a_star(g, i, d))
end

length.(paths) |> findmin
paths[28]
cartesianindex(grid, 28)