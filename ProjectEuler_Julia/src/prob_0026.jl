using Primes


"""
Decompose a number into its powers of 10 and the 
largest string of 9's that can be divided by the 
remaining factor.
"""
function nines(num::Int)
	n = big(num)
	f = factor(num)
	f[2] = 0
	f[5] = 0
	r = prod(f)
	r == 1 && return 0
	i = 0
	while true
		n += 9 * big(10)^i
		n % r == 0 && break
		i += 1
	end
	return i + 1
end


let r = 0, n = 0
	for i = 1:999
		d = nines(i)
		if d > r
			n = i
			r = d
		end
	end
	(number = n, reps = r)
end