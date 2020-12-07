lines = readlines("day7.txt")

struct Bag
    adjective::String
    color::String
end

struct Rule
    parent::Bag
    child::Bag
    amount::Int
end  

function getRules(line)
    re = match(r"(.*) (.*) bags contain (.*).", line)
    c = re.captures
    parent = Bag(c[1],c[2])
    contains = split(c[3], ",")

    rules = []
    for contain in contains
        cre = match(r"(.*) (.*) (.*) bags?", contain)
        if cre == nothing
            continue # No rule where this bag is parent
        end
        cc = cre.captures 
        amount = parse(Int, cc[1])
        child = Bag(cc[2],cc[3])
        rules = [rules; Rule(parent, child, amount)]
    end
    return rules
end

function findParents(rules, child::Bag)
    parents = map(
        b->b.parent,
        filter(
            r->r.child == child, 
            rules
        )
    )

    for parent in parents
        parents = [parents; findParents(rules, parent)]
    end

    return parents
end

function getChildBagAmount(rules, parent::Bag)
    filteredRules = filter(
            r->r.parent == parent,
            rules
        )

    amount = 1
    for rule in filteredRules
        childBagAmount = getChildBagAmount(rules, rule.child)
        amount += rule.amount * childBagAmount
    end

    return amount
end

function part1()
    rules = []
    for line in lines
        rules = [rules;getRules(line)]
    end
    
    parents = findParents(rules, Bag("shiny", "gold"))
    print(length(unique(parents)))
end

function part2()
    rules = []
    for line in lines
        rules = [rules;getRules(line)]
    end
    
    amount = getChildBagAmount(rules, Bag("shiny", "gold"))
    print(amount - 1) # Do not include the gold bag itself
end

part2()