function check_child(age)
    if age < 12
        println("Is child")
    else
        println("Not a child")
    end
end


function check_child_v2(age)
    if age < 12
        return true
    else
        return false
    end
end


function loop_run()
    sum = 0
    for i = 1:10
        sum = sum + i
    end
    println(sum)
end

loop_run()
check_child(11)
check_child(14)