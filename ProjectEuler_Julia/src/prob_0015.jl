# use a pure mathematical approach
# there will always be exactly `n` Down moves and `n` Right moves
# sequences will look like DRRDDDDRR...
# how many permutations exist? Use multinomial theorem => 40! / (20! × 20!)

f(n) = sum(binomial(n,k)^2 for k in 0:n)
