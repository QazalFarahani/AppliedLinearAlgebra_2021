using LinearAlgebra

n = parse(Int, readline())
A = zeros(n, n)
for i = 1:n
    A[i,:] = [parse(Float64, x) for x in split(readline())]
end
b = [parse(Float64, x) for x in split(readline())]
X_t = [parse(Float64, x) for x in split(readline())]
C_t = zeros(n, n)
T_min = -1
for i = 0:n-1
    for j = 0:i-1
        global C_t[:,n-j] = A * C_t[:,n-j]
    end
    global C_t[:,n-i] = b
    if rank(C_t) == rank([C_t X_t])
        global T_min = i + 1
        break
    end
end
C_tp = zeros(n, T_min)
for i = 1:T_min
    global C_tp[:,i] = C_t[:,n-T_min+i]
end
u_t = C_tp\X_t
println(T_min)
for i = 1:n
    [print(round(x, digits=4), " ") for x in C_tp[i,:]]
    println()
end
[print(round(x, digits=4), " ") for x in u_t]
