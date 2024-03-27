using Transducers
using Primes

proper_divisor_sum(n) = sum(divisors(n)[begin:end-1])

function divisor_sum_status(n)
    k = proper_divisor_sum(n)
    if k < n
        return Val{:deficient}()
    elseif k == n
        return Val{:perfect}()
    else
        return Val{:abundant}()
    end
end

is_abundant(::Val{T}) where {T} = false
is_abundant(::Val{:abundant}) = true
is_abundant(n) = is_abundant(divisor_sum_status(n))

z = 12:28123 |> Filter(is_abundant) |> collect

z_sums = z .+ z' |> Set
pos_nums = Set(1:28123)
x = setdiff!(pos_nums, z_sums)
