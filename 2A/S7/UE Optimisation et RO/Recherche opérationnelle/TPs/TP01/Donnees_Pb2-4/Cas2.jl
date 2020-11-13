# fonctionne pour JuMP version 0.21.5
using Cbc
using JuMP

# data
N = 6 # nombre de fluides de chaque magasin disponibles
c = [1 1 2 3 3 2] # cout de chaque magasin
b1 = [2.5 1 1 2 2 1] # Stocks de fluides par magasin
A1 = 1* Matrix(I, 6, 6)
b2 = [3 3]
A2 = [1 0 1 0 1 0;0 1 0 1 0 1]

# set optimizer
model = Model(Cbc.Optimizer)

# define variables
@variable(model, Fluides[1:N] >= 0)

# define objective function
@objective(model, Min, sum(c[i]*Fluides[i] for i in 1:N))

# define constraints
for i in 1:length(b1)
    @constraint(model, sum(A1[i,j]*Fluides[j] for j in 1:N) <= b1[i])
end
for i in 1:length(b2)
    @constraint(model, sum(A2[i,j]*Fluides[j] for j in 1:N) == b2[i])
end

# run optimization
optimize!(model)
