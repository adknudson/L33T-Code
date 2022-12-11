priority(c::Char) = _priority(Val(c))
for c in 'a':'z'
    @eval _priority(::Val{$c}) = $(Int(c) - 96)
end
for c in 'A':'Z'
    @eval _priority(::Val{$c}) = $(Int(c) - 64 + 26)
end

function shareditem(s::String)
    n = length(s)
    return first(intersect(s[begin:n÷2], s[n÷2+1:end]))
end

open("data/input03", "r") do f
    s = 0
    while !eof(f)
        s += priority(shareditem(readline(f)))
    end
    @show s
end

groupshareditem(a::String, b::String, c::String) = first(intersect(a, b, c))

open("data/input03", "r") do f
    s = 0
    i = 0
    buffer = Vector{String}()
    
    while !eof(f)
        push!(buffer, readline(f))
        i += 1

        if i % 3 == 0
            r = groupshareditem(buffer[1:3]...)
            s += priority(r)
            empty!(buffer)
        end
    end

    @show s
end