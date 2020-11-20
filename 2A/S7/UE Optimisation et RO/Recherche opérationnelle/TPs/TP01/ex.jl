# fonctionne pour JuMP version 0.21.5
using Cbc
using JuMP

# data
N = 2 # nombre de fluide
M = 3 # nombre de magasin
L = 2 # nombre de demande

c = [1 2 3 ; 1 3 2] # prix de vente par fluide par magasin
b = [2.5 1 2 ; 1 2 1] # limite de stock par fluide par magasin
a = [2 0 ; 1 3]#Quantié par demande

# set optimizer
model = Model(Cbc.Optimizer)

# define variables
@variable(model, fluide[1:N,1:M,1:L] >= 0)

# define objective function
@objective(model, Min,sum( sum( sum(c[i,j]*fluide[i,j,k] for j in 1:M) for i in 1:N) for k in 1:L))

# define constraints
for i in 1:N
    for j in 1:M
        @constraint(model, sum(fluide[i,j,k] for k in 1:L) <= b[i,j])
    end
    for k in 1:L
        @constraint(model, sum(fluide[i,j,k] for j in 1:M) == a[k,i])
    end
end

# run optimization
optimize!(model)

# print solution
println("Solution obtenue:")
println("\t coût = $(objective_value(model))")
for i in 1:N
    for j in 1:M
        for k in 1:L
            println("\t quantite de fluide $i $j $k = $(value(fluide[i,j,k]))")
        end
    end
end
