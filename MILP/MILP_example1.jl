using JuMP, GLPK

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)
    
    #declare set
    meals = ["A", "B", "C"]

    #declare variables
    x = @variable(model, [meals], Int, lower_bound=0, base_name="x")

    #declare parameters
    C = Dict("A" => 10, "B" => 15, "C" => 12) 
    R = Dict("A" => 25, "B" => 30, "C" => 28) 

    #objective function
    @objective(model, Max, sum(x[m]*(R[m]-C[m]) for m in meals))

    #constraints
    @constraint(model,  sum(x[m] for m in meals) <= 300)
    @constraint(model, x["A"]*C["A"] >= 0.1 * sum(x[m]*C[m] for m in meals))
    @constraint(model, x["C"]-x["B"] <= 50)

    #solve the problem
    optimize!(model)

    #print solutions
    for m in meals
        println("x$(m) = $(value(x[m]))")
    end
    println("Obj Function = $(objective_value(model))")

    #printing model
    println("\n")
    println(model)

end

run()