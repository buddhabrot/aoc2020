lines = readlines("day21.txt")
inIngredient = Dict()
allIngredients = Dict()
withAllergens = Dict()

for line in lines
    m = match(r" \(contains (.*)\)", line)
    if (m !== nothing)
        allergens = split(m.captures[1], ", ")
        ingredients = split(replace(line, m.match=>""), " ")
    else
        allergens = []
        ingredients = split(line, " ")
    end

    for allergen in allergens
        if (haskey(inIngredient, allergen))
            inIngredient[allergen] = filter(i->i in ingredients, inIngredient[allergen])
        else
            inIngredient[allergen] = ingredients
        end
    end

    for ingredient in ingredients
        if (haskey(withAllergens,ingredient))
            # Allergens are not always marked
            withAllergens[ingredient] = unique([withAllergens[ingredient]; allergens])
        else
            withAllergens[ingredient] = allergens
        end
    end

    if (length(allergens) == 0)
        for allergen in keys(inIngredient)
            inIngredient[allergen] = filter(i->!(i in ingredients), inIngredient[allergen])
        end

        for ingredient in ingredients
            withAllergens[ingredient] = []
        end
    end

    for ingredient in ingredients
        if (haskey(allIngredients,ingredient))
            allIngredients[ingredient] += 1
        else
            allIngredients[ingredient] = 1
        end
    end
end

function search(inIngredient, withAllergens)
    # Try choice, return false if inconsistent
    freeness = map(k->(k,length(inIngredient[k])), collect(keys(inIngredient)))

    choices = sort(filter(f->f[2]>1,freeness), by=c->c[2])

    backUpWithAllergens = copy(withAllergens)
    backupInIngredients = copy(inIngredient)

    for (allergen,_) in choices
        for ingredient in inIngredient[allergen]
            withAllergens[ingredient] = [allergen]

            for otherAllergen in keys(inIngredient)
                if otherAllergen == allergen
                    inIngredient[otherAllergen] = [ingredient]
                else
                    inIngredient[otherAllergen] = filter(i->!(i == ingredient), inIngredient[otherAllergen])
                end
            end

            if(search(inIngredient, withAllergens)!== false)
                return inIngredient
            else
                for key in keys(backupInIngredients)
                    inIngredient[key] = backupInIngredients[key]
                end
                for key in keys(backUpWithAllergens)
                    withAllergens[key] = backUpWithAllergens[key]
                end        
            end
        end
    end

    flawed = false

    ingredientAppeared = Dict()
    for otherAllergen in keys(inIngredient)
        if(length(inIngredient[otherAllergen]) == 0)
            # println("Inconsistent, ", otherAllergen, " has no ingredients ")
            return false
        end

        for ingredient in inIngredient[otherAllergen]
            if (haskey(ingredientAppeared, ingredient))
                #println("Inconsistent, ", ingredient, " appears multiple times ")
                return false
            else
                ingredientAppeared[ingredient] = otherAllergen            
            end
        end
    end

    if (length(choices) > 0)
        #println("Inconsistent, choices remain")
        return false
    end

    return inIngredient
end

ingredientsWithAllergents = unique(collect(Iterators.flatten(values(inIngredient))))
ingredientsWithNoAllergens = unique(filter(i->!(i in ingredientsWithAllergents), collect(keys(allIngredients))))

total = 0
for ingredient in ingredientsWithNoAllergens
    global total
    total += allIngredients[ingredient]
end

println("Part 1:", total)

for ingredient in ingredientsWithNoAllergens
    withAllergens[ingredient] = []
    for otherAllergen in keys(inIngredient)
        inIngredient[otherAllergen] = 
            filter(i->!(i == ingredient), inIngredient[otherAllergen])
    end
end

searchResults = search(inIngredient, withAllergens)
sortedSearchResults = sort(collect(keys(searchResults)))
sortedIngredients = map(k->searchResults[k][1], sortedSearchResults)
println("Part 2:", join(sortedIngredients,","))
