using LinearAlgebra

n = parse(Int, readline())
A_m = zeros(n, n)
V = zeros(n, n)
for i = 1:n
    A_m[i,:] = [parse(Float64 , x) for x in split(readline())]
end
for i = 1:n
    V[:,i] = [parse(Float64 , x) for x in split(readline())]
end
V_inv = inv(V)
P = zeros(n^2, n)
for i = 1:n
    P[:,i] = (V[:,i] * transpose(V_inv[i,:]))[:]
end
eig_vals = pinv(P) * A_m[:]
A_m = V * Diagonal(eig_vals) * V_inv
for i = 1:n
    [print(x, " ") for x in A_m[i,:]]
    println()
end
