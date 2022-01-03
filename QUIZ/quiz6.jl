using LinearAlgebra
using MAT

S_file = matopen("S.mat")
S = read(S_file, "S")
w_file = matopen("w.mat")
w = read(w_file, "w")

H_tail = zeros(72,95)
H_head = zeros(72,95)
for i = 1:72
    for j = 1:95
        if S[i, j] > 0
            H_head[i,j] = 1
        end
        if S[i, j] < 0
            H_tail[i, j] = 1
        end
    end
end

l1 = []
d_tail_v = zeros(95, 1)
for i = 1:95
    d_tail_v[i, 1] = sum(H_tail[:,i]) * w[i]
    if sum(H_tail[:,i]) == 0
        push!(l1, i)
    end
end
d_head_v = zeros(95, 1)
for i = 1:95
    d_head_v[i] = sum(H_head[:,i]) * w[i]
end
d_tail_e = zeros(72, 1)
for i = 1:72
    d_tail_e[i] = sum(H_tail[i,:])
end
d_head_e = zeros(72, 1)
l2 = []
for i = 1:72
    d_head_e[i] = sum(H_head[:,i])
end

S = [S zeros(72)]
S = S'
S = [S zeros(96)]
S = S'

H_tail = zeros(73,96)
H_head = zeros(73,96)
for i = 1:73
    for j = 1:93
        if S[i, j] > 0
            H_head[i,j] = 1
        end
        if S[i, j] < 0
            H_tail[i, j] = 1
        end
    end
end

d_tail_v = zeros(96, 1)
for i = 1:96
    d_tail_v[i] = sum(H_tail[:,i]) * w[i]
end
print(d_tail_v)
d_head_v = zeros(96, 1)
for i = 1:96
    d_head_v[i] = sum(H_head[:,i]) * w[i]
end
d_tail_e = zeros(73, 1)
for i = 1:73
    d_tail_e[i] = sum(H_tail[i,:])
end
d_head_e = zeros(73, 1)
for i = 1:73
    d_head_e[i] = sum(H_head[:,i])
end


P = inv(d_tail_v) * H_tail * Diagonal(W) * inv(d_head_e) * H_head'
laplacian = identity(73) - (P + P')/2
Q = eigvecs(P)
lambda = eigvals(P)
