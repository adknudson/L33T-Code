mutable struct Node
    x::Int
    y::Int
    Node() = new(0, 0)
end

istouching(n1::Node, n2::Node) = abs(n1.x - n2.x) <= 1 && abs(n1.y - n2.y) <= 1

step!(node::Node; dx::Int=0, dy::Int=0) = (node.x += dx; node.y += dy; node)

function step!(head::Node, dir::Symbol)
    if dir == :U
        step!(head; dy=+1)
    elseif dir == :D
        step!(head; dy=-1)
    elseif dir == :L
        step!(head; dx=-1)
    elseif dir == :R
        step!(head; dx=+1)
    else
        error("Unrecognized direction received: '$dir'")
    end
end

pos(node::Node) = CartesianIndex(node.x, node.y)

function planmove(leader::Node, follower::Node)
    istouching(leader, follower) && return (0, 0)
    
    # directly above/below or left/right
    if leader.x == follower.x || leader.y == follower.y
        leader.x == follower.x && return (0, leader.y > follower.y ? 1 : -1)
        leader.y == follower.y && return (leader.x > follower.x ? 1 : -1, 0)
    end

    # diagonally above/below and left/right
    return (leader.x > follower.x ? 1 : -1, leader.y > follower.y ? 1 : -1)
end


function simulate(path::String, n::Int)
    node = [Node() for _ in 1:n]
    visited_spaces = [Vector{CartesianIndex}() for _ in 1:n]
    for i in 1:n
        push!(visited_spaces[i], pos(node[i]))
    end

    open(path, "r") do io
        while !eof(io)
            r = readline(io)
            dir, steps = split(r)
            dir = Symbol(dir)
            steps = parse(Int, steps)

            for _ in 1:steps
                step!(first(node), dir)
                push!(first(visited_spaces), pos(first(node)))
                
                for j in 2:n
                    dx, dy = planmove(node[j-1], node[j])
                    step!(node[j]; dx=dx, dy=dy)
                    push!(visited_spaces[j], pos(node[j]))
                end 
            end
        end
    end

    return visited_spaces
end

steps = simulate("data/input09_test", 2)
last(steps) |> Set |> length

steps = simulate("data/input09_test", 10)
last(steps) |> Set |> length
