function creategrid(path)
    lines = readlines(path)
    rows = length(lines)
    cols = length(first(lines))
    
    grid = zeros(Int, (rows, cols))
    
    for (row, r) in enumerate(lines)
        for (col, c) in enumerate(r)
            grid[row, col] = parse(Int, c)
        end
    end

    return grid
end


isedge(grid, row, col) = row == 1 || col == 1 || row == size(grid, 1) || col == size(grid, 2)
isedge(grid, pos::CartesianIndex) = isedge(grid, pos.I...)


function isvisible(grid, row, col)
    isedge(grid, row, col) && return true

    height = grid[row, col]
    rowvals = grid[row, :]
    colvals = grid[:, col]

    # from the left
    all(<(height), Iterators.take(rowvals, col - 1)) && return true
    # from the right
    all(<(height), Iterators.rest(rowvals, col + 1)) && return true
    #from the top
    all(<(height), Iterators.take(colvals, row - 1)) && return true
    # from the bottom
    all(<(height), Iterators.rest(colvals, row + 1)) && return true

    return false
end

isvisible(grid, pos::CartesianIndex) = isvisible(grid, pos.I...)


grid = creategrid("data/input08")
count(x -> isvisible(grid, x), CartesianIndices(grid))


function scenicscore(grid, row, col)
    height = grid[row, col]
    rowvals = grid[row, :]
    colvals = grid[:, col]

    scoreabove = 0
    if row > 1
        vals = Iterators.reverse(collect(Iterators.take(colvals, row - 1)))
        for v in vals
            scoreabove += 1
            v >= height && break
        end
    end

    scorebelow = 0
    if row < size(grid, 1)
        vals = Iterators.rest(colvals, row + 1)
        for v in vals
            scorebelow += 1
            v >= height && break
        end
    end

    scoreleft = 0
    if col > 1
        vals = Iterators.reverse(collect(Iterators.take(rowvals, col - 1)))
        for v in vals
            scoreleft += 1
            v >= height && break
        end
    end

    scoreright = 0
    if col < size(grid, 2)
        vals = Iterators.rest(rowvals, col + 1)
        for v in vals
            scoreright += 1
            v >= height && break
        end
    end

    return scoreabove * scorebelow * scoreleft * scoreright
end

scenicscore(grid, pos::CartesianIndex) = scenicscore(grid, pos.I...)


grid = creategrid("data/input08")

maximum(i -> scenicscore(grid, i), CartesianIndices(grid))
