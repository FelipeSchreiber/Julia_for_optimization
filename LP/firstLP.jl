using JuMP,GLPK 

function run()
    model = Model()
    set_optimizer(model,GLPK.Optimizer)

    #declare variables
    p1 = @variable(model,lower_bound=0)
    p2 = @variable(model,lower_bound=0)

    #objective function
    @objective(model,Max, 2p1+5p2)

    #constraints
    @constraint(model,p1+3p2 <= 1000)
    @constraint(model,3p1+4p2 <= 3000)
    @constraint(model,p1+p2 <= 600.5)

    #optimize
    optimize!(model)
    println("p1 = $(value(p1))")
    println("p2 = $(value(p2))")
    println("objective = $(objective_value(model))")

end

run()