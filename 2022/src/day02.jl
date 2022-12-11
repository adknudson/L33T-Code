abstract type Hand end
struct Rock <: Hand end
struct Paper <: Hand end
struct Scissors <: Hand end

Base.cmp(::Rock, ::Paper) = -1
Base.cmp(::Rock, ::Scissors) = 1
Base.cmp(::Paper, ::Rock) = 1
Base.cmp(::Paper, ::Scissors) = -1
Base.cmp(::Scissors, ::Rock) = -1
Base.cmp(::Scissors, ::Paper) = 1
Base.cmp(::T, ::T) where T <: Hand = 0

function cmpinv(theirs::Hand, outcome::Int)
    return _cmpinv(theirs, Val(outcome))
end

_cmpinv(::Rock, ::Val{1}) = Paper()
_cmpinv(::Rock, ::Val{-1}) = Scissors()
_cmpinv(::Paper, ::Val{1}) = Scissors()
_cmpinv(::Paper, ::Val{-1}) = Rock()
_cmpinv(::Scissors, ::Val{1}) = Rock()
_cmpinv(::Scissors, ::Val{-1}) = Paper()
_cmpinv(::T, ::Val{0}) where T <: Hand = T()

value(::Rock) = 1
value(::Paper) = 2
value(::Scissors) = 3

lut = Dict{String, Hand}(
    "A" => Rock(),
    "B" => Paper(),
    "C" => Scissors(),
    "X" => Rock(),
    "Y" => Paper(),
    "Z" => Scissors(),
)

function evaluate(mine::AbstractString, theirs::AbstractString)
    score = value(lut[mine])
    outcome = cmp(lut[mine], lut[theirs])    

    if outcome == 0
        score += 3
    elseif outcome > 0
        score += 6
    else
        score += 0
    end

    return score
end

score = open("data/input02", "r") do f
    score = 0
    while(!eof(f))
        theirs, mine = split(readline(f))
        score += evaluate(mine, theirs)
    end

    return score
end

@show score


lut2 = Dict(
    "A" => Rock(),
    "B" => Paper(),
    "C" => Scissors(),
    "X" => -1,
    "Y" => 0,
    "Z" => 1,
)

function evaluate2(mine::AbstractString, theirs::AbstractString)
    theirHand = lut[theirs]
    outcome = lut2[mine]
    myHand = cmpinv(theirHand, outcome)

    score = value(myHand)

    if outcome == 0
        score += 3
    elseif outcome > 0
        score += 6
    else
        score += 0
    end

    return score
end

score2 = open("data/input02", "r") do f
    score = 0
    while(!eof(f))
        theirs, mine = split(readline(f))
        score += evaluate2(mine, theirs)
    end

    return score
end

@show score2