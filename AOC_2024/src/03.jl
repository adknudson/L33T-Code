module Day03

const mul_re = r"mul\((\d{1,3}),(\d{1,3})\)"
const do_re = r"do\(\)"
const dont_re = r"don't\(\)"

function process_instructions(s)
    [parse.(Int, m) for m in eachmatch(mul_re, s)]
end


struct DoCommand
    enabled::Bool
    index::Int
end

function get_ranges(s)
    cs = Vector{DoCommand}()
    push!(cs, DoCommand(true, firstindex(s)))
    push!(cs, DoCommand(false, lastindex(s)))

    dos = findall(do_re, s)
    donts = findall(dont_re, s)

    for d in dos
        push!(cs, DoCommand(true, d.start))
    end

    for d in donts
        push!(cs, DoCommand(false, d.start))
    end


    sort(cs, by=x->x.index)
end

function popfirst_until!(vs, cond)
    isempty(vs) && return nothing
    while !isempty(vs)
        r = popfirst!(vs)
        if cond(r) == true
            return r
        end
    end
    return nothing
end

function get_enabled_ranges(s)
    rs = get_ranges(s)
    ms = Vector{UnitRange{Int}}()

    r = popfirst_until!(rs, x -> x.enabled == true)
    start = r.index
    r = popfirst_until!(rs, x -> x.enabled == false)
    stop = r.index

    push!(ms, start:stop)

    while !isempty(rs)
        r = popfirst_until!(rs, x -> x.enabled == true)
        start = r.index
        r = popfirst_until!(rs, x -> x.enabled == false)
        stop = r.index

        push!(ms, start:stop)
    end

    return ms
end

function process_instructions_with_commands(s)
    ms = Vector{Vector{Int}}()
    for r in get_enabled_ranges(s)
        append!(ms, process_instructions(s[r]))
    end
    return ms
end

end

using .Day03
using Test

ex = """xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"""

ms = Day03.process_instructions(ex)

@test length(ms) == 4
@test ms[1] == [2,4]
@test ms[2] == [5,5]
@test ms[3] == [11,8]
@test ms[4] == [8,5]
@test sum(prod, ms) == 161

ex2 = """xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"""
Day03.get_ranges(ex2)
Day03.get_enabled_ranges(ex2)
ms2 = Day03.process_instructions_with_commands(ex2)

@test length(ms2) == 2
@test ms2[1] == [2,4]
@test ms2[2] == [8,5]

s = read("./data/03.txt", String)
ms = Day03.process_instructions(s)
sum(prod, ms)

ms2 = Day03.process_instructions_with_commands(s)
sum(prod, ms2)
