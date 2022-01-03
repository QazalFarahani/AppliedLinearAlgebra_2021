using LinearAlgebra
using DelimitedFiles
using Plots

data = readdlm("HW7/data1.txt", ' ')
data[1, 1] = -5.150393896416424
scatter(data[:,1], data[:,2])
t = zeros(1007, 6)

function cross_validation(A, y)
    A = [A y]
    A = shufflerows(A)
    y = A[:,size(A)[2]]
    A = A[:,1:size(A)[2]-1]
    errors = []
    m = size(A)[1]
    n = size(A)[2]
    l = Int(floor(1/5 * m))
    for i = 1:5
        A_train = zeros(4*l, n)
        A_test = zeros(l, n)
        y_train = zeros(4*l, 1)
        y_test = zeros(l, 1)
        A_test = A[(i-1)*l+1:i*l,:]
        y_test = y[(i-1)*l+1:i*l,:]
        y_train = y[setdiff(1:end, (i-1)*l+1:i*l),:]
        A_train = A[setdiff(1:end, (i-1)*l+1:i*l),:]
        θ = pinv(A_train)*y_train
        ŷ = A_test * θ
        push!(errors, norm(y_test - ŷ))
    end
    return sum(errors)/length(errors)
end

function shufflerows(a)
    for i = size(a, 1):-1:2
        j = rand(1:i)
        a[i,:], a[j,:] = a[j,:], a[i,:]
    end
    return a
end

function build_A(data, k, multiplier, break_points)
    max_x = maximum(data[:,1])
    min_x = minimum(data[:,1])
    l = Int(ceil((max_x - min_x)/k))
    if size(break_points)[1] == 0
        break_points = get_uniform_points(break_points, min_x, l, k)
    end
    A = zeros(size(data)[1] + k-1, 2*k)
    for p = 1:size(data)[1]
        x = data[p, 1]
        pos = Int(floor((x - min_x)/l)) + 1
        A[p, pos*2-1] = 1
        A[p, pos*2] = x
    end
    for i = 1:k-1
        p = size(A)[1]-k+1+i
        A[p, 2*i-1] = 1 * multiplier
        A[p, 2*i] = break_points[i] * multiplier
        A[p, 2*(i+1)-1] = -1 * multiplier
        A[p, 2*(i+1)] = -break_points[i] * multiplier
    end
    return A
end

function get_uniform_points(break_points, min_x, l, k)
    for i = 1:k-1
        push!(break_points, min_x + i*l)
    end
    return break_points
end

function find_K(data, max_k)
    error = []
    for i = 1:max_k
        A = build_A(data, i, 10, [])
        y = zeros(size(data)[1] + i-1, 1)
        [y[j, 1] = data[j, 2] for j = 1:size(data)[1]]
        push!(error, cross_validation(A, y))
    end
    return error
end


function plot_data(θ, intervals)
    funcs = []
    n = size(θ)[1]
    for i = 1:Int(n/2)
        f1(x) = θ[2*i-1]+θ[2*i]*x
        push!(funcs, f1)
    end
    for i = 1:Int(n/2)
        plot!(funcs[i], [intervals[i], intervals[i+1]], linewidth = 5)
    end
end


function get_break_points(θ, data)
    n = size(θ)[1]
    max_x = maximum(data[:,1])
    min_x = minimum(data[:,1])
    l = Int(ceil((max_x - min_x)/k))
    points = []
    slope = θ[2]
    for i = 2:Int(n/2)
        if (abs(θ[2*i] - slope) > 2)
            push!(points, min_x+(i-1)*l)
        end
        slope = θ[2*i]
    end
    return points
end


function get_intervals(data, k)
    intervals = []
    max_x = maximum(data[:,1])
    min_x = minimum(data[:,1])
    l = Int(ceil((max_x - min_x)/k))
    push!(intervals, min_x)
    for i = 1:k-1
        push!(intervals, min_x+i*l)
    end
    push!(intervals, max_x)
    return intervals
end


e = find_K(data, 20)
plot(e)
k = 12
y = zeros(size(data)[1] + k-1, 1)
[y[j, 1] = data[j, 2] for j = 1:size(data)[1]]
θ = pinv(build_A(data, k, 100, [])) * y
plot_data(θ, get_intervals(data, k))
plot!([0], legend=false)

points = get_break_points(θ, data)

k = size(points)[1] + 1
y = zeros(size(data)[1] + k-1, 1)
[y[j, 1] = data[j, 2] for j = 1:size(data)[1]]
θ = pinv(build_A(data, k, 100, points)) * y
max_x = maximum(data[:,1])
min_x = minimum(data[:,1])
plot_data(θ, [min_x points' max_x])
plot!([0], legend=false)
