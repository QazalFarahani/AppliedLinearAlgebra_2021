using LinearAlgebra
using DelimitedFiles
using BlockArrays
using Plots

data = readdlm("HW8\\agent-food.txt", ' ')
nlist = []
mlist = []
for i = 1:1843
    push!(mlist, data[i,:][1])
    push!(nlist, data[i,:][2])
end
global H = zeros(2, 2)
(m, mc) = findmax(mlist)
(n, nc) = findmax(nlist)
C = zeros(Int(m), Int(n))
for i = 1:1843
    C[Int(data[i,:][1]), Int(data[i,:][2])] = data[i,:][3]
end
function find_k(R, multiplier, maxiteration)
    m = size(R)[1]
    n = size(R)[2]
    errors = []
    for r = 1:maxiteration
        U = get_random_U(m, r)
        V = zeros(r, n)
        for i = 1:5
            println("iter: ", r)
            V = solve(U, R, multiplier)
            U = solve(V', R', multiplier)'
        end
        push!(errors, norm(R - U*V))
    end
    return errors
end

function get_random_U(m, r)
    U = zeros(m, r)
    for i = 1:m
        for j = 1:r
            U[i, j] = 2 * rand()
        end
    end
    return U
end

function solve(A, B, multiplier)
    m = size(B)[1]
    n = size(B)[2]
    r = size(A)[2]
    B = B[:]
    cols = [r for i = 1:n]
    rows = [m for i = 1:n]
    A′ = BlockArray{Float64}(zeros(m*n, r*n), rows, cols)
    for  i =1:n
        A′[Block(i, i)] = A
    end
    A′ = Array(A′)
    A″ = [multiplier * I(r*n); A′]
    B′ = [zeros(r*n, 1); B]
    X = A″\B′
    X = reshape(X, r, n)
    return X
end

function calaculate_UV(R, r, multiplier)
    m = size(R)[1]
    n = size(R)[2]
    U = get_random_U(m, r)
    V = zeros(r, n)
    for i = 1:5
        V = solve(U, R, multiplier)
        U = solve(V', R', multiplier)'
    end
    return U, V
end

function compare(user_id, U)
    vector = []
    n = size(U)[1]
    user = U[user_id,:]
    for i = 1:n
        cos = (dot(U[i,:], user))/(norm(U[i,:]) * norm(user))
        if !isnan(cos)
            push!(vector, cos)
        end
    end
    return vector
end

function get_closest_ones(vector)
    (min, index) = findmin(vector)
    closest = []
    for i = 1:11
        (value, index) = findmax(vector)
        push!(closest, index)
        vector[index] = min
    end
    return closest
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
            (distances[i], assignment[i]) = findmin([norm(points[i,:] - reps[j]) for j = 1:k])
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
        assignment, reps, J = kmeans(points, k, maxiteration)
        temp = 0.0
        for j = 1:length(points[:,1])
            center = reps[assignment[j]]
            temp += norm(points[j,:] - center)
        end
        push!(wss, temp)
    end
    return wss
end

err = find_k(C, 0.3, 7)
plot(err)
r = 6
user_id = 58
U, V = calaculate_UV(C, r, 0.3)
closest = get_closest_ones(compare(58, U))
wss = find_elbow(V', 10, 100)
k = 4
kmeans(V', k, 100)
