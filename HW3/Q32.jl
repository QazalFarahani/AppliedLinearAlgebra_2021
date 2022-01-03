using LinearAlgebra


n = parse(Int, readline())
m = parse(Int, readline())
A = zeros(Float64, n, m)
for i = 1:m
    v = [parse(Float64, x) for x in split(readline(), " ")]
    A[:,i] = v
end
x = [parse(Float64, x) for x in split(readline(), " ")]
B = [A x]
function gram_shmidt(C, Q, p)
    for i = 1:p
        a = C[:,i]
        t = zeros(Float64, n, 1)
        for j = i-1:-1:1
            t += (dot(a, Q[:,j]))*Q[:,j]
        end
        a -= t
        Q[:,i] = a/norm(a)
    end
    for i = 1:p
        for j = 1:n
            print(Q[:,i][j], " ")
        end
        println("")
    end
end
if rank(B) > rank(A)
    gram_shmidt(B, zeros(Float64, n, m + 1), m + 1)
else
    gram_shmidt(A, zeros(Float64, n, m), m)
end
