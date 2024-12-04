using Test

input_to_matrix(io) = reduce(vcat, permutedims(collect(l)) for l in eachline(io))

function is_xmas(cv)
    length(cv) == 4 || return false
    all(cv .== ('X', 'M', 'A', 'S')) && return true
    all(cv .== ('S', 'A', 'M', 'X')) && return true
    return false
end

function is_mas(cv)
    length(cv) == 3 || return false
    all(cv .== ('M', 'A', 'S')) && return true
    all(cv .== ('S', 'A', 'M')) && return true
    return false
end

function part1(A)
    r, c = size(A)
    h, w = (4, 4)

    n = 0

    # diagonals
    for i in 1:(r-h+1)
        for j in 1:(c-w+1)
            B = @view A[i:(i+h-1), j:(j+w-1)]
            d1 = @view B[1:5:16]
            d2 = @view B[4:3:13]
            is_xmas(d1) && (n += 1)
            is_xmas(d2) && (n += 1)
        end
    end

    # horizontals
    for i in 1:r
        for j in 1:(c-w+1)
            hv = @view A[i, j:(j+w-1)]
            is_xmas(hv) && (n += 1)
        end
    end

    # verticals
    for i in 1:(r-h+1)
        for j in 1:c
            vv = @view A[i:(i+h-1), j]
            is_xmas(vv) && (n += 1)
        end
    end

    return n
end

function part2(A)
    r, c = size(A)
    h, w = (3, 3)

    n = 0

    for i in 1:(r-h+1)
        for j in 1:(c-w+1)
            B = @view A[i:(i+h-1), j:(j+w-1)]
            d1 = @view B[1:4:9]
            d2 = @view B[3:2:7]
            is_mas(d1) && is_mas(d2) && (n += 1)
        end
    end

    return n
end

ex = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""

let A = input_to_matrix(IOBuffer(ex))
    @show part1(A)
    @show part2(A)
    nothing
end


let A = open(input_to_matrix, "./data/04.txt")
    @show part1(A)
    @show part2(A)
    nothing
end
