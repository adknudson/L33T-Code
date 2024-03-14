using Transducers

function reverse_num(k::Signed)
	r = 0
	while k != 0
		k, p = divrem(k, 10)
		r = 10 * r + p
	end
	return r
end

is_palindrome(k::Signed) = reverse_num(k) == k

endsin_1379(x::Int) = mod(x, 10) ∈ (1, 3, 7, 9)

function search_space(n::Int=2)
    # we assume that the first digit is 9 and ends in 1,3,7,9
	itr = range(9*10^(n-1), 10^n - 1; step=1) |> Filter(endsin_1379)
	return Iterators.product(itr, itr)
end

function largest_palindrome(n)
	search_space(n) |>
		Map(prod) |>
		Filter(is_palindrome) |>
		maximum
end

@time largest_palindrome(3)
