elves = Vector{Int}()

open("data/input01", "r") do f
    while (!eof(f))
        line = readline(f)
        calories = 0
        while(!isempty(line) && !eof(f))
            calories += parse(Int, line)
            line = readline(f)
        end
        push!(elves, calories)
    end
end

@show maximum(elves)

@show sort(elves; rev=true)[1:3] |> sum