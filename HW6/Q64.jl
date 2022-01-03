using LinearAlgebra

n = parse(Int, readline())
c = parse(Float64, readline())
μ = [parse(Float64, x) for x in split(readline())]
A = zeros(n, n)
for i = 1:n
    A[i,:] = [parse(Float64, x) for x in split(readline())]
end
eig_vals = eigvals(A)
Ainv = inv(A' + A)
λ = sqrt(c / (μ' * (Ainv * A * Ainv) * μ))
answer = λ * μ' * Ainv
[print(x, " ") for x in answer]
