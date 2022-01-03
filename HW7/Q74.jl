using LinearAlgebra
using BlockArrays

function calc_H(G, G_tilde, n, m)
    if m < 2*n
        return "not defined"
    end
    cols = [m for i = 1:n]
    rows = [n for i = 1:2*n]
    A = BlockArray{Float64}(zeros(2*n^2, m*n), rows, cols)
    for i = 1:n
        A[Block(i, i)] = G'
        A[Block(n+i, i)] = G_tilde'
    end
    b = [Matrix(I, n, n)[:];Matrix(I, n, n)[:]]
    A = Array(A)
    x = A\b
    H = zeros(n, m)
    [H[i,:] = x[(i-1)*m+1:i*m] for i = 1:n]
end

G = [[2 3];[1 0];[0 4];[1 1];[-1 2]]
G_tilde = [[-3 -1];[-1 0];[2 -3];[-1 -3];[1 2]]
m = size(G)[1]
n = size(G)[2]
H = calc_H(G, G_tilde, n, m)
