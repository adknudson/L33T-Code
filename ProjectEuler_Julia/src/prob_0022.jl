using LinearAlgebra: dot

names = read("data/0022_names.txt", String) |>
    x -> split(x, ',') |>
    x -> map(y -> strip(y, '"'), x)

sort!(names)

letter_score(c::Char) = Int(c) - 64
name_score(s) = sum(letter_score(c) for c in s)

n = length(names)

dot(1:n, name_score.(names))
