using LinearAlgebra
using DelimitedFiles
using Plots

data = readdlm("data1.txt", ',')
scatter(data[:,1], data[:,2])

n = length(data[:,1])
A = zeros(3, 3)
b = zeros(3, 1)
for i = 1:n
    x = data[i, 1]
    y = data[i, 2]
    A[1, 1] += x^2
    A[2, 1] += x * y
    A[1, 2] += x * y
    A[3, 1] += x
    A[1, 3] += x
    A[2, 2] += y^2
    A[2, 3] += y
    A[3, 2] += y
    b[1, 1] += x * (x^2 + y^2)
    b[2, 1] += y * (x^2 + y^2)
    b[3, 1] += (x^2 + y^2)
end
A[3, 3] = n
u = pinv(A) * b
x_0 = u[1]/2
y_0 = u[2]/2
r = sqrt(4 * u[3] + u[1]^2 + u[2]^2)/2
function circle(h, k, r)
    θ = LinRange(0, 2*π, 500)
    h .+ r*sin.(θ), k .+ r*cos.(θ)
end
plot!(circle(x_0, y_0, r), aspect_ratio = 1)
