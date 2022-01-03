using LinearAlgebra
using Plots
using Polynomials

A = zeros(10, 10)
for i = 1:10
    for j = 1:10
        A[i, j] = rand()
    end
end

l = []
B = zeros(10, 2)
B[:,1] = [1;1;1;1;1;1;1;1;1;1]
B[:,2] = [1;2;3;4;5;6;7;8;9;10]
x = [1;2;3;4;5;6;7;8;9;10]
push!(l, B)
for i = 2:10
    B = zeros(10, i+1)
    C = l[length(l)]
    B = [C (Diagonal(C[:,size(C)[2]])*x)]
    push!(l, B)
end

function cross_validation(A, y, degree)
    errors = []
    for i = 1:5
        A_train = zeros(8, degree + 1)
        A_test = zeros(2, degree + 1)
        y_train = zeros(8, 1)
        y_test = zeros(2, 1)
        A_test[1,:] = A[2*i,:]
        A_test[2,:] = A[2*i-1,:]
        y_test[1,:] = y[2*i,:]
        y_test[2,:] = y[2*i-1,:]
        y_train = y[setdiff(1:end, 2*i, 2*i-1), :]
        A_train = A[setdiff(1:end, 2*i, 2*i-1), :]
        θ = pinv(A_train)*y_train
        ŷ = A_train * θ
        push!(errors, norm(y_train - ŷ))
    end
    return sum(errors)/length(errors)
end
print(A)

best_degree = []
print(best_degree)
errors = []
for row  = 1:10
    y = A[row,:]
    degree_error = []
    for degree = 1:10
        C = l[degree]
        push!(degree_error, cross_validation(C, y, degree))
    end
    push!(errors, degree_error)
    push!(best_degree, findmin(degree_error)[2])
end

plot(errors[1])
plot(errors[2])
plot(errors[3])
plot(errors[4])
plot(errors[5])
plot(errors[6])
plot(errors[7])
plot(errors[8])
plot(errors[9])
plot(errors[10])
print(best_degree)

answers = []
for row = 1:10
    y = A[row,:]
    C = l[best_degree[row]]
    push!(answers, pinv(C)*y)
end
points = zeros(10, 10)
for i = 1:10
    row = answers[i]
    for j = 1:length(row)
        points[i, j] = row[j]
    end
end


function kmeans(points, k, maxiteration; tol = 1e-5)
    N = length(points[:,1])
    n = length(points[1,:])
    Jprevious = Inf
    distances = zeros(N)
    reps = [zeros(n) for i = 1:k]
    assignment = [rand(1:k) for i in 1:N]
    for iteration = 1:maxiteration
        for i = 1:k
            group = [j for j=1:N if assignment[j] == i]
            temp = zeros(n)
            for i in group
                temp += points[i,:]
            end
            reps[i] =  temp / length(group)
        end
        for i = 1:N
            (distances[i], assignment[i]) = findmin([function_norm(points[i,:], reps[j]) for j = 1:k])
        end
        J = norm(distances)^2 / N
        if iteration > 1 && abs(J - Jprevious) < tol * J
            return assignment, reps, J
        end
        Jprevious = J
    end
end

function find_elbow(points, kmax, maxiteration)
    wss = []
    for k = 1:kmax
        print(2)
        assignment, reps, J = kmeans(points, k, maxiteration)
        temp = 0.0
        for j = 1:length(points[:,1])
            center = reps[assignment[j]]
            temp += norm(points[j,:] - center)
        end
        push!(wss, temp)
    end
    plot(wss)
end

function function_norm(f, r)
    func1 = Polynomial(f)
    func2 = Polynomial(r)
    res = integrate((func1 - func2)^2)
    return res(10) - res(0)
end

find_elbow(points, 4, 100)
assignment, reps, J = kmeans(points, 3, 100)
print(assignment)
