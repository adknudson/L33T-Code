using Chairmarks

function find_special_triple(num)
    for a in 1:num
        for b in a:num
            c = num - a - b
            a^2 + b^2 == c^2 && return (a,b,c)
        end
    end
end


@b find_special_triple(1000) |> prod


f(b) = (1e6 - 2000b) / (2000 - 2b)

function g(num)
    for b in 1:num÷2
        a = f(b)
        isinteger(a) && return a * b * (1000-a-b)
    end
    return 0.0
end

g(1000) |> Int
