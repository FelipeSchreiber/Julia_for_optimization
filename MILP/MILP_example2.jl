using JuMP, GLPK

function run()
    model = Model()
    set_optimizer(model, GLPK.Optimizer)

    #declare set
    machines = [1,2]
    jobs = [1,2,3]

    #declare parameters
    T = Dict((1,1) => 2, (1,2) => 4, (1,3)=> 3,
             (2,1) => 1, (2,2) => 100, (2,3) => 2)
    M = 100

    #declare variables
    x = @variable(model, [machines,jobs], Bin, base_name="x")
    s = @variable(model, [machines,jobs], lower_bound=0, base_name="s")
    e = @variable(model, [machines,jobs], lower_bound=0, base_name="e")
    emax = @variable(model, lower_bound=0, base_name="emax")


    #objective function
    @objective(model, Min, emax)

    #constraints
    @constraint(model, [j=jobs], sum(x[m,j] for m in machines) == 1)
    @constraint(model, x[2,2] == 0)
    @constraint(model, [m=machines, j=jobs], e[m,j] >= s[m,j] + x[m,j]*T[m,j])
    @constraint(model, [m=machines, j=jobs], emax >= e[m,j])
    for m in machines, n in machines, j in jobs
        if j != minimum(jobs)
            @constraint(model, s[m,j] >= s[n,j-1])
        end
    end
    @constraint(model, [m=machines, n=machines], s[m,2] >= e[n,1] + 1.5)

    #solve the problem
    optimize!(model)

    #print solutions
    for j in jobs, m in machines
        if value(x[m,j]) > 0.5
            println("Machine $(m) has been allocated in Job $(j)")
            println("s[$(m),$(j)] = $(value(s[m,j]))")
            println("e[$(m),$(j)] = $(value(e[m,j]))")
            println("----------------------------------------------")
        end        
    end
    println("Obj Function = $(objective_value(model))")

end

run()