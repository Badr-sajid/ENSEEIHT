# fonctionne pour JuMP version 0.21.5
# fonctionne pour JuMP version 0.21.5
using Cbc
using JuMP

# data
NbF = 2 # nombre de fluides disponibles
NbM = 3 # nombre de magasins
NbD = 2 # nombre de demandes
c = [1 2 3; 1 3 2] # cout de chaque magasin
b = [2.5 1 2; 1 2 1] # Stocks de fluides par magasin
d = [2 0; 1 3]

# set optimizer
model = Model(Cbc.Optimizer)

# define variables
@variable(model, Fluides[1:NbF, 1:NbM , 1:NbD] >= 0, Int)

# define objective function
@objective(model, Min, sum(c .* sum(Fluides[:,:,k] for k in 1:NbD)))

# define constraints
for i in 1:NbF
    for k in 1:NbD
        @constraint(model, sum(Fluides[i,j,k] for j in 1:NbM) == d[k,i])
    end # for
end
for i in 1:NbF
    for j in 1:NbM
        @constraint(model, sum(Fluides[i,j,k] for k in 1:NbD) <= b[i,j])
    end # for
end


# run optimization
optimize!(model)
println("la solution est : ")
Fluides
println("\t coût = $(objective_value(model))")
for i in 1:NbF
    for j in 1:NbM
        for k in 1:NbD
            println("\t quantite de fluide $i $j $k = $(value(Fluides[i,j,k]))")
        end
    end
end
