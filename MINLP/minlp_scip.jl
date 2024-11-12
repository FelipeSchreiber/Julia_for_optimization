using JuMP, AmplNLWriter, SCIP

function run()
    #model
    model = Model(SCIP.Optimizer)

    #variables
    x = @variable(model, integer=true, lower_bound=0, upper_bound=100, start=0, base_name="x")
    y = @variable(model, lower_bound=0, upper_bound=100, start=0, base_name="y")

    #obj function
    @objective(model, Max, x + x*y)

    #constraint
    @constraint(model, -x + 2*y*x <= 7)
    @constraint(model, 2*x + y <= 14)
    @constraint(model, 2*x - y <= 10)

    #solve
    optimize!(model)

    #print
    println("x = $(value(x))")
    println("y = $(value(y))")
    println("OF = $(objective_value(model))")

end

run()