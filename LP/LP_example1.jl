using JuMP, GLPK

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)
    
    #declare variables
    xA = @variable(model, lower_bound=0)
    xB = @variable(model, lower_bound=0)
    xC = @variable(model, lower_bound=0)

    #declare parameters
    CA = 10 
    CB = 15
    CC = 12
    RA = 25
    RB = 30
    RC = 28

    #objective function
    @objective(model, Max, xA*(RA-CA) + xB*(RB-CB) + xC*(RC-CC))

    #constraints
    @constraint(model, xA + xB + xC <= 300)
    @constraint(model, xA*CA >= 0.1 * (xA*CA + xB*CB + xC*CC))
    @constraint(model, xC-xB <= 50)

    #solve the problem
    optimize!(model)

    #print solutions
    println("xA = $(value(xA))")
    println("xB = $(value(xB))")
    println("xC = $(value(xC))")
    println("Obj Function = $(objective_value(model))")

end

run()