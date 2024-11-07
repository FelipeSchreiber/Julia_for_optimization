using XLSX, DataFrames

filename = "dataNameAges.xlsx"

xf = XLSX.readxlsx(filename)[1][:]
df = DataFrame(xf[2:end,:], Symbol.(xf[1,:]))

println(df)

println("\n-------------------------------")
println(df[:,"Name"])

println("\n-------------------------------")
println(df[df.Age.>=17,"Name"])