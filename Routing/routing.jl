using JuMP, GLPK, DataFrames, XLSX, CSV

function run()
    #read inputs
    dfNodes = DataFrame(XLSX.readtable("input.xlsx", "nodes"))
    dfArcs = DataFrame(XLSX.readtable("input.xlsx", "arcs"))

    #parameters and sets
    D = dfArcs.distance
    nodeOrigin = first(dfNodes[dfNodes.description .== "origin", "node"])
    nodeDest = first(dfNodes[dfNodes.description .== "destination", "node"])
    nodeMiddle = dfNodes[dfNodes.description .== "middle point", "node"]
    setNodes = dfNodes.node 
    setArcs = dfArcs.arc
    nNodes = nrow(dfNodes)
    nArcs = nrow(dfArcs)

    #model
    model = Model(GLPK.Optimizer)
    
    #variables
    x = @variable(model, [setArcs], Bin, base_name="x")

    #objective function
    @objective(model, Min, sum(x[a]*D[a] for a in setArcs))

    #constraints
    nodesExitingOrigin = dfArcs[dfArcs.from .== nodeOrigin, "arc"]
    nodesEnteringDest = dfArcs[dfArcs.to .== nodeDest, "arc"]
    @constraint(model, sum(x[a] for a in nodesExitingOrigin) == 1)
    @constraint(model, sum(x[a] for a in nodesEnteringDest) == 1)
    @constraint(model, [n=nodeMiddle], sum(x[a] for a in dfArcs[dfArcs.from .== n, "arc"]) == sum(x[a] for a in dfArcs[dfArcs.to .== n, "arc"]))

    #optimize
    optimize!(model)

    #print solution
    println("status = ", termination_status(model))
    println("OF (total distance)= ", objective_value(model))

    dfArcs.activated = zeros(nArcs)
    
    for a in setArcs
        dfArcs[a, "activated"] = value(x[a])
    end

    println(dfArcs)

    CSV.write("output.csv", dfArcs)

end

run()