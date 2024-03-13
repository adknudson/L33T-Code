using DataStructures

function position_of_first_n_unique(iterable, n::Int)
    buf = CircularBuffer{eltype(iterable)}(n)

    next = iterate(iterable)
    while next !== nothing
        (item, state) = next
    
        push!(buf, item)
    
        state > n && break
        next = iterate(iterable, state)
    end

    while next !== nothing
        (item, state) = next
        
        length(unique(buf)) == n && break
        push!(buf, item)
    
        next = iterate(iterable, state)
    end
    
    last(next) - 2
end

r = readline("data/input06")

position_of_first_n_unique(r, 4)
position_of_first_n_unique(r, 14)