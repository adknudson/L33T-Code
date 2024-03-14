using Transducers

is_3_or_5(x::Int) = x % 3 == 0 || x % 5 == 0
sum_3_or_5_to_n(n::Int) = 1:n-1 |> Filter(is_3_or_5) |> sum
sum_3_or_5_to_n(10)
