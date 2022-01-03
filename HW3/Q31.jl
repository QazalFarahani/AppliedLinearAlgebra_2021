using LinearAlgebra

n = parse(Int, readline())
v = [parse(Float64, x) for x in split(readline(), " ")]
m = length(v)
A = Array{Float64}(undef, n, m)
A[1,:] = v
for i = 2:n
    v = [parse(Float64, x) for x in split(readline(), " ")]
    A[i,:] = v
end
y = [parse(Float64, x) for x in split(readline(), " ")]
B = [A y]
b = false
j = -1
for i = 1:n
    if rank(B[setdiff(1:end, i), :]) == rank(A[setdiff(1:end, i), :])
        b = true
        j = i
        break
    end
end
if b 
    print(j)
else
    print("NO SENSOR HAVE FAILED")
end
