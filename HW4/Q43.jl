using LinearAlgebra

n = parse(Int, readline())
vctor = [parse(Float64, x) for x in split(readline())]
A = zeros(n, length(vctor))
A[1,:] = vctor
for i = 2:n
    A[i,:] = [parse(Float64, x) for x in split(readline())]
end
q = [parse(Float64, x) for x in split(readline())]
r = parse(Int, readline())

function index_list(v)
    max = maximum(v)
    list = []
    i = 1
    for e in v
        if abs(e - max) <= 1.0e-2
            print(i, " ")
        end
        i = i + 1
    end
end

index_list(transpose(A) * q)
println()
normalizedA = zeros(n, length(vctor))
normalizedQ = normalize(q)
for i = 1:length(vctor)
    normalizedA[:,i] = normalize(A[:,i])
end
index_list(transpose(normalizedA) * normalizedQ)
println()

U,s,V = svd(normalizedA)
LRA = U[:,1:r] * Diagonal(s[1:r]) * V[:,1:r]'
index_list(transpose(LRA) * normalizedQ)
