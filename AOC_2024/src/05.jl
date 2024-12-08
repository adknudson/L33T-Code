using Test

ex = """47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"""


struct PageOrderRule
    before::Int
    after::Int
end

function is_compliant(pages::Vector{Int}, rule::PageOrderRule)
    rule.before ∈ pages || return true
    rule.after ∈ pages || return true
    i = findfirst(==(rule.before), pages)
    j = findfirst(==(rule.after), pages)
    return i < j
end

is_compliant(pages::Vector{Int}) = Base.Fix1(is_compliant, pages)

is_compliant(rule::PageOrderRule) = Base.Fix2(is_compliant, rule)

function is_compliant(pages::Vector{Int}, rules::Vector{PageOrderRule})
    return all(is_compliant(pages), rules)
end

is_compliant(rules::Vector{PageOrderRule}) = Base.Fix2(is_compliant, rules)

middle_element(xs::AbstractVector{T}) where {T} = xs[length(xs) ÷ 2 + 1]

function make_compliant!(pages::Vector{Int}, rules::Vector{PageOrderRule})
    is_compliant(pages, rules) && return nothing

    while !is_compliant(pages, rules)
        for rule in rules
            rule.before ∈ pages || continue
            rule.after ∈ pages || continue
            is_compliant(pages, rule) && continue

            i = findfirst(==(rule.before), pages)
            j = findfirst(==(rule.after), pages)

            t = pages[i]
            pages[i] = pages[j]
            pages[j] = t
        end
    end

    return nothing
end

function read_input(io)
    rule_re = r"^(\d+)\|(\d+)$"
    rules = Vector{PageOrderRule}()
    while !eof(io)
        r = readline(io)
        m = match(rule_re, r)

        isnothing(m) && break
        length(m) == 2 || error()

        before, after = parse.(Int, m)
        push!(rules, PageOrderRule(before, after))
    end

    page_re = r"^\d+(,\d+)*$"
    pages = Vector{Vector{Int}}()
    while !eof(io)
        r = readline(io)
        m = match(page_re, r)

        isnothing(m) && continue

        ps = parse.(Int, split(r, ','))
        push!(pages, ps)
    end

    return (rules, pages)
end

rules, pages = read_input(IOBuffer(ex))
compliant_pages = filter(is_compliant(rules), pages)
noncompliant_pages = filter(x -> !is_compliant(x, rules), pages)
for page in noncompliant_pages
    make_compliant!(page, rules)
end
sum(middle_element, noncompliant_pages)


rules, pages = open(read_input, "./data/05.txt")
compliant_pages = filter(is_compliant(rules), pages)
sum(middle_element, compliant_pages)
noncompliant_pages = filter(x -> !is_compliant(x, rules), pages)
for page in noncompliant_pages
    make_compliant!(page, rules)
end
sum(middle_element, noncompliant_pages)
