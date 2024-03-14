using Transducers

const _units = Dict(
    0 => "",
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen",
    20 => "twenty",
    30 => "thirty",
    40 => "forty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety"
)

const _powers10 = Dict(
    0 => "one",
    1 => "ten",
    2 => "hundred",
    3 => "thousand",
    6 => "million",
    9 => "billion",
    12 => "trillion",
    15 => "quadrillion",
    18 => "quintillion",
    21 => "sextillion",
    24 => "septillion",
    27 => "octillion",
    30 => "nonillion",
    33 => "decillion",
    36 => "undecillion",
    39 => "duodecillion",
    42 => "tredecillion",
    45 => "quattuordecillion",
    48 => "quindecillion",
    51 => "sexdecillion",
    54 => "septendecillion",
    57 => "octodecillion",
    60 => "novemdecillion",
    63 => "vigintillion",
    66 => "unvigintillion",
    69 => "duovigintillion",
    72 => "trevigintillion",
    75 => "quattuorvigintillion",
    78 => "quinvigintillion",
    81 => "sexvigintillion",
    84 => "septenvigintillion",
    87 => "octovigintillion",
    90 => "novemvigintillion",
    93 => "trigintillion",
)

function num_to_word(n::Integer)
    n < 0 && return "negative " * num_to_word(-n)

    if n ≤ 20
        return _units[n]
    elseif n < 100
        d, r = divrem(n, 10)
        if r == 0
            return _units[d*10]
        else
            return _units[d*10] * "-" * _units[r]
        end
    elseif n < 1_000
        d, r = divrem(n, 100)
        if r == 0
            return _units[d] * " hundred"
        else
            return _units[d] * " hundred and " * num_to_word(r)
        end
    else # n >= 1000
        k = 3
        d, r = divrem(n, 1000)

        s = if r == 0
            ""
        elseif r < 100
            "and " * num_to_word(r)
        else
            num_to_word(r)
        end

        while d ≥ 1000
            d, r = divrem(d, 1000)

            if r != 0
                s = num_to_word(r) * " " * _powers10[k] * (isempty(s) ? "" : " " * s)
            end

            k += 3
        end

        s = num_to_word(d) * " " * _powers10[k] * (isempty(s) ? "" : " " * s)

        return s
    end

end

1:1000 |>
    Map(num_to_word) |>
    Map(s -> count(c -> c ∉ (' ', '-'), s)) |>
    sum
