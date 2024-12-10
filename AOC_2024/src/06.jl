ex = """....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"""

function rotated(d::Char)
    if d == '^'
        return '>'
    elseif d == '>'
        return 'v'
    elseif d == 'v'
        return '<'
    elseif d == '<'
        return '^'
    end
end

guard_pos(grid) = findfirst(∈(('>', 'v', '^', '<')), grid)

function next_spot(grid)
    p = guard_pos(grid)
    d = grid[p]

    pnext = if d == '^'
        p.I .+ (-1, 0)
    elseif d == '>'
        p.I .+ (0, 1)
    elseif d == 'v'
        p.I .+ (1, 0)
    elseif d == '<'
        p.I .+ (0, -1)
    end

    return CartesianIndex(pnext)
end

function step!(grid)
    p = guard_pos(grid)
    pnext = next_spot(grid)

    if !checkbounds(Bool, grid, pnext)
        grid[p] = 'X'
        return false
    end

    if grid[pnext] == '#'
        grid[p] = rotated(grid[p])
        return true
    end

    if grid[pnext] == '.'
        grid[pnext] = grid[p]
        grid[p] = 'X'
        return true
    end

    if grid[pnext] == 'X'
        grid[pnext] = grid[p]
        grid[p] = 'X'
        return true
    end

    return false
end

function run!(grid)
    running = step!(grid)
    while running
        running = step!(grid)
    end
    return grid
end

read_input(io) = reduce(vcat, [permutedims(collect(l)) for l in eachline(io)])

grid = read_input(IOBuffer(ex))
run!(grid)
count(==('X'), grid)


grid = open(read_input, "./data/05.txt")
run!(grid)
count(==('X'), grid)
