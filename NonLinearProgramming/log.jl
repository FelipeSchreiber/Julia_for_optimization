using JuMP, Ipopt

function run()
    #create model
    model = Model(Ipopt.Optimizer)

    #define parameters
    D = 1000
    C = 900
    Pav = 100

    #define variables
    p = @variable(model, lower_bound=0, upper_bound=200, base_name="p")
    v = @variable(model, lower_bound=0, upper_bound=C, base_name="v")

    #define OF
    @NLobjective(model, Max, v*p)

    #Constraint
    @NLconstraint(model, v == D * exp(-0.2*p) / (exp(-0.2*p) + exp(-0.2*Pav)))

    #starting point
    set_start_value(p, Pav)

    #solve problem
    set_optimizer_attribute(model, "print_level", 0)
    optimize!(model)

    #print
    println("p = $(value(p))")
    println("v = $(value(v))")
    println("OF (revenue) = $(objective_value(model))")

end

run()