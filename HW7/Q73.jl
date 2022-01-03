using LinearAlgebra
using DelimitedFiles

data = readdlm("HW7\\data3.txt", '\t')
m = size(data)[1]
n = size(data)[2]
label = data[:,n]
data = data[:,1:n-1]
n_p = 100
D = zeros(m, n_p)

for i = 1:m
    temp = 0
    for j = 1:n
        temp += rand() * data[i, j]
    end
    [D[i, k] = temp for k = 1:n_p]
end
