using DataStructures: OrderedDict, DefaultDict

struct Monkey
    id::Int
    items::Vector{BigInt}
    op::Function
    divisor::Int
    trueroute::Int
    falseroute::Int
end

Base.push!(m::Monkey, x) = push!(m.items, x)
Base.popfirst!(m::Monkey) = popfirst!(m.items)
Base.isempty(m::Monkey) = isempty(m.items)


function Monkey(io::IOStream)
    while !eof(io)
        r = readline(io)
        startswith(r, "Monkey") || error("First line expected to match 'Monkey \\d:'. Got '$r'")

        m = match(r"^Monkey (\d+):$", r)
        id = parse(Int, m[1])
        
        r = readline(io)
        starting_items = [parse(BigInt, m.match) for m in eachmatch(r"\d+", r)]

        r = readline(io)
        m = match(r"Operation: new = (old|\d+) ([\+\-\*\/]) (old|\d+)", r)
        left = m[1] == "old" ? :x : parse(Int, m[1])
        op = Symbol(m[2])
        right = m[3] == "old" ? :x : parse(Int, m[3])
        operation = eval(:(x -> $op($left, $right)))

        r = readline(io)
        m = match(r"Test: divisible by (\d+)", r)
        divisor = parse(Int, m[1])

        r = readline(io)
        m = match(r"\d+", r)
        trueroute = parse(Int, m.match)
        
        r = readline(io)
        m = match(r"\d+", r)
        falseroute = parse(Int, m.match)

        r = readline(io)
        isempty(r) || error("Expected an empty line")
    
        return Monkey(id, starting_items, operation, divisor, trueroute, falseroute)
    end
end


function getmonkeys(path::AbstractString)
    monkeys = OrderedDict{Int, Monkey}()

    open(path, "r") do io
        while !eof(io)
            monkey = Monkey(io)
            monkeys[monkey.id] = monkey
        end
    end

    return monkeys
end


function playround!(monkeys::AbstractDict{Int, Monkey}, inspections::AbstractDict{Int, Int})
    for (id, monkey) in monkeys
        while !isempty(monkey)
            inspections[id] += 1
            item = popfirst!(monkey)
            item = monkey.op(item)
            item ÷= 3

            if mod(item, monkey.divisor) == 0
                push!(monkeys[monkey.trueroute], item)
            else
                push!(monkeys[monkey.falseroute], item)
            end
        end
    end
end



inspections = DefaultDict{Int, Int}(0)
monkeys = getmonkeys("data/input11")

for _ in 1:20
    playround!(monkeys, inspections)
end

values(inspections) |> collect |> sort |> reverse |> x -> x[1:2] |> prod



function playround2!(monkeys::AbstractDict{Int, Monkey}, inspections::AbstractDict{Int, Int})
    L = lcm((m.divisor for m in values(monkeys))...)

    for (id, monkey) in monkeys
        isempty(monkey) && continue

        while !isempty(monkey)
            inspections[id] += 1

            # monkey inspects item
            item = popfirst!(monkey)

            # worry level is updated
            item = monkey.op(item)

            # manage worry levels
            item %= L
            
            if item % monkey.divisor == 0
                push!(monkeys[monkey.trueroute], item)
            else
                push!(monkeys[monkey.falseroute], item)
            end
        end
    end
end


inspections = DefaultDict{Int, Int}(0)
monkeys = getmonkeys("data/input11")

for _ in 1:10000
    playround2!(monkeys, inspections)
end

monkeys
inspections

values(inspections) |> collect |> sort |> reverse |> x -> x[1:2] |> prod