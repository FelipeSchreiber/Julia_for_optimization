using JuMP, GLPK

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)

    #solve the problem
    set_optimizer_attribute(model, "msg_lev", GLPK.GLP_MSG_ON)
    set_optimizer_attribute(model, "tm_lim", 5)

    #GAP
    #GLPK     set_optimizer_attribute(model, "mip_gap", 0.001)
    #Gurobi   set_optimizer_attribute(model, "MIPGap", 0.001)
    #Cbc      set_optimizer_attribute(model, "allowableGap", 0.001)

    #Time lime
    #GLPK     set_optimizer_attribute(model, "tm_lim", 60*30)
    #Gurobi   set_optimizer_attribute(model, "TimeLime", 60*30)
    #Cbc      set_optimizer_attribute(model, "Sec", 60*30)
    
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