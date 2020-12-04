
function check_valid(fields)
    mandatory = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    checks = Dict()
    checks["byr"] = byr -> (length(byr) == 4 && parse(Int, byr) >= 1920 && parse(Int, byr) <= 2002)
    checks["iyr"] = iyr -> (length(iyr) == 4 && parse(Int, iyr) >= 2010 && parse(Int, iyr) <= 2020)
    checks["eyr"] = eyr -> (length(eyr) == 4 && parse(Int, eyr) >= 2020 && parse(Int, eyr) <= 2030)
    checks["hgt"] = hgt -> ((occursin(r"^[0-9]+in$", hgt) && tryparse(Int,hgt[1:end-2]) >= 59 && tryparse(Int,hgt[1:end-2]) <= 76) || 
                            (occursin(r"^[0-9]+cm$", hgt) && tryparse(Int,hgt[1:end-2]) >= 150 && tryparse(Int,hgt[1:end-2]) <= 193))
    checks["hcl"] = hcl -> occursin(r"^#[0-9a-f]{6}$", hcl)
    checks["ecl"] = ecl -> ecl in split("amb blu brn gry grn hzl oth", " ")
    checks["pid"] = pid -> occursin(r"^[0-9]{9}$", pid)
    present = filter(fld->haskey(fields,fld), mandatory)

    if (length(present) != length(mandatory))
        return false
    end

    ok = filter(fld->(haskey(checks, fld) && checks[fld](fields[fld])), mandatory)
    return length(ok) == length(mandatory)
end

lines = [readlines("day4.txt");""]
fields = Dict()
valid = 0
for line in lines
    if length(line) == 0
         if check_valid(fields) 
            global valid += 1
         end

         global fields = Dict()
    end

    assigns = split(line, ' ')

    pairs = map(assign->split(assign, ':'), assigns)
    for pair in pairs
        if (length(pair) > 1)
            fields[pair[1]] = pair[2]
        end
    end
end

print(valid)