using LinearAlgebra

n = parse(Int, readline())
u = [parse(Float64, x) for x in split(readline())]
y = [parse(Float64, x) for x in split(readline())]

a_0 = u - y
a_1 = y
A_2 = zeros(n,n)
for i = 2:n
    A_2[i, i] = 1
    A_2[i, i - 1] = -1
end
a_2 = transpose(A_2) * A_2 * y
A_3 = zeros(n,n)
for i = 2:n - 1
    A_3[i, i] = -2
    A_3[i, i - 1] = 1
    A_3[i, i + 1] = 1
end
a_3 = transpose(A_3) * A_3 * y

A = [a_1 a_2 a_3]
A_transpose = transpose(A)
answer = pinv(A_transpose * A) * A_transpose * a_0

[println(round(x)) for x in answer]
