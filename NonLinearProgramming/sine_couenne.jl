using JuMP, AmplNLWriter, Couenne_jll

function run()
    #model
    model = Model(() -> AmplNLWriter.Optimizer(Couenne_jll.amplexe))

    #variables
    x = @variable(model, lower_bound=-5, upper_bound=5, start=5, base_name="x")
    y = @variable(model, lower_bound=-5, upper_bound=5, start=5, base_name="y")

    #Obj function
    @NLobjective(model, Max, cos(x+1) + cos(x) * cos(y))

    #solve
    optimize!(model)

    #print
    println("OF = $(objective_value(model))")
    println("x = $(value(x))")
    println("y = $(value(y))")

end

run()