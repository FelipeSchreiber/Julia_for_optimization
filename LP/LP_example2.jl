using JuMP, GLPK, Printf

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)

    #declare set
    funds = ["A", "B", "C"]

    #declare parameters
    R = Dict("A" => 0.08, "B" => 0.10, "C" => 0.06)
    K = Dict("A" => 0.12, "B" => 0.15, "C" => 0.10)
    Total = 1e6

    #declare variables
    x = @variable(model, [funds], lower_bound=0, base_name="x")

    #objective function
    @objective(model, Max, sum(x[f]*R[f] for f in funds))

    #constraints
    @constraint(model, sum(x[f] for f in funds) == 1)
    @constraint(model, sum(x[f]*K[f] for f in funds) <= 0.13)
    @constraint(model, x["A"] >= 0.20)
    @constraint(model, x["B"] <= 0.40)

    #solve the problem
    optimize!(model)

    #print solutions
    for f in funds
        #println("x[$(f)] = $(round(value(x[f])*100, digits=2))% or $(round(value(x[f])*Total, digits=2))\$")
        @printf("x[%s] = %.2f%% or %.2f\$\n", f, value(x[f])*100, value(x[f])*Total)
    end

    println("\n")
    println(model)

end

run()