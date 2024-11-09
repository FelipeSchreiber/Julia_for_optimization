using JuMP, GLPK

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)

    #declare set
    setI = [1, 2, 3]
    setIcond = [2, 3]
    setJ = ["A", "B"]

    #declare variables
    x = @variable(model, [setI, setJ], base_name="x")
    y = @variable(model, [setI, setJ], base_name="y")

    #declare contraints
    @constraint(model, sum(x[i,j] for i in setI for j in setJ) == 1)
    @constraint(model, [i=setI, j=setJ], x[i,j]+ y[i,j] <= 1)
    @constraint(model, [i=setIcond], sum(x[i,j] + y[i-1,j] for j in setJ) <= 1)

    println(model)

end

run()