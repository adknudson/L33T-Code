isstrictsubset(a::UnitRange, b::UnitRange) = first(b) ∈ a && last(b) ∈ a
oneisstrictsubset(a::UnitRange, b::UnitRange) = isstrictsubset(a, b) || isstrictsubset(b, a)

function rangefromstring(a::AbstractString)
    start, stop = split(a, '-')
    return parse(Int, start):parse(Int, stop)
end

open("data/input04", "r") do f
    s = 0
    while !eof(f)
        r = readline(f)
        a, b = split(r, ',')
        A = rangefromstring(a)
        B = rangefromstring(b)
        s += oneisstrictsubset(A, B) ? 1 : 0
    end
    @show s
end

rangesoverlap(a::UnitRange, b::UnitRange) = !isempty(collect(intersect(a, b)))

open("data/input04", "r") do f
    s = 0
    while !eof(f)
        r = readline(f)
        a, b = split(r, ',')
        A = rangefromstring(a)
        B = rangefromstring(b)
        s += rangesoverlap(A, B) ? 1 : 0
    end
    @show s
end