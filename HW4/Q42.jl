using LinearAlgebra

n = parse(Int, readline())
x_0 = [parse(Float64, x) for x in split(readline())]
P = Array{Float64}(undef, n, n)
A = Array{Float64}(undef, n, n)
T = Array{Float64}(undef, n, n)

for i = 1:n
    P[i,:] = [parse(Float64, x) for x in split(readline())]
    A[i,:] = P[i,:]
    T[i,:] = P[i,:]
end

b = true
for i = 1:100
    if norm(T * P - T) < 1.0e-6
        [println(x) for x in x_0' * T * P]
        global b = false
        break
    end
    global T = T * P
end
if b
    dict = Dict{Int, Array{Int}}()
    for i = 1:n
        dict[i] = []
    end
    M = Matrix{Int}(I, n, n)
    for j = 0:2n
        for i = 1:n
            if abs(M[i ,i]) > 1.0e-6
                push!(dict[i], j)
            end
        end
        global M = M * A
    end
    list = []
    for i = 1:n
        push!(list, gcd(dict[i]))
    end
    [println(x) for x in list]
end
