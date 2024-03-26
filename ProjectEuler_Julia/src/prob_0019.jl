const _year = [
    31, # jan
    28, # feb
    31, # mar
    30, # apr
    31, # may
    30, # jun
    31, # jul
    31, # aug
    30, # sep
    31, # oct
    30, # nov
    31, # dec
]

const _leapyear = [
    31, # jan
    29, # feb
    31, # mar
    30, # apr
    31, # may
    30, # jun
    31, # jul
    31, # aug
    30, # sep
    31, # oct
    30, # nov
    31, # dec
]


function is_leapyear(year)
    year % 4 != 0 && return false

    if year % 100 == 0
        return year % 400 == 0 ? true : false
    end

    return true
end

days(year) = is_leapyear(year) ? _leapyear : _year

const _dow = [:mon, :tue, :wed, :thu, :fri, :sat, :sun]
day_of_week(day) = _dow[(day % 7) + 1]


last_year = (1 .+ days(1900)) .% 7

num_sun = 0
for year in 1901:2000
    first_day_of_year = last(last_year)
    this_year = (first_day_of_year .+ days(year)) .% 7
    num_sun += count(==(6), this_year)
    last_year = this_year
end

num_sun


using Transducers, Dates
@time Date(1901, 1, 1):Month(1):Date(2000, 12, 31) |>
    Filter(d -> dayofweek(d) == 7) |>
    collect |> length
