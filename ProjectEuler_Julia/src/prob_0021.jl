using Primes

proper_divisor_sum(n) = sum(divisors(n)[begin:end-1])

function amicable_number(n)
    k1 = proper_divisor_sum(n)
    k1 == n && return nothing
    k2 = proper_divisor_sum(k1)
    return k2 == n ? k1 : nothing
end

z = Set{Int}()

for i in 1:9999
    j = amicable_number(i)
    isnothing(j) && continue
    push!(z, i)
    push!(z, j)
end
