using LinearAlgebra

m = parse(Int, readline())
n = parse(Int, readline())
A = zeros(m, n)
b = zeros(m, 1)
for i = 1:m
    A[i,:] = [parse(Float64, x) for x in split(readline())]
end
b = [parse(Float64, x) for x in split(readline())]
A_n = zeros(n, n)
[A_n[i,:] = A[i,:] for i=1:n]
X = zeros(n, m-n+1)
G = transpose(A_n) * A_n
h = transpose(A_n) * b[1:n]
X[:,1] = G\h
for i = n+1:m
    global G = G + A[i,:] * transpose(A[i,:])
    global h = h + b[i] * A[i,:]
    X[:,i-n+1] = G\h
end
X = [round(x, digits=3) for x in X]
for i=1:n
    [print(x, " ") for x in X[i,:]]
    println()
end
