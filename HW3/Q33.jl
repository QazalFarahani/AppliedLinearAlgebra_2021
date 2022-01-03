using LinearAlgebra

t = parse(Int, readline())
m = parse(Int, readline())
p = [parse(Float64, x) for x in split(readline(), " ")]
f = [parse(Float64, x) for x in split(readline(), " ")]
s = [parse(Float64, x) for x in split(readline(), " ")]

L = zeros(Float64, m, m)
L[1,:] = f
for i = 1:m-1
    setindex!(L, s[i], i+1, i)
end
E = Diagonal(eigvals(L))^t
Q = eigvecs(L)
res = Q * E * inv(Q) * p
res = [round(x) for x in res]
[println(x) for x in res]
