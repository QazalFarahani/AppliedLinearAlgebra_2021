using LinearAlgebra
using Plots

scatter(points[:,1], points[:,2], title = "two moons")
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
    plot(wss)
end

function spectral_clustering(points, k, maxiter)
    n = length(points[:,1])
    W = computing_similarity(points, n)
    D = zeros(n, n)
    for i = 1:n
        D[i, i] = sum(W[i,:])
    end
    L = D-W
    eig_vecs = eigvecs(L)
    data = zeros(n, 2)
    data[:,1] = eig_vecs[:,1]
    data[:,2] = eig_vecs[:,2]
    assignment, reps, J = kmeans(data, k, maxiter)
    return assignment
end

function computing_similarity(data, n)
    w = zeros(n, n)
    for i = 1:n
        for j = 1:n
            w[i,j] = count_sim(data[i,:],data[j,:])
        end
    end
    return w
end

function count_sim(x::Vector,y::Vector)
    return exp(-15*norm(x-y)^2)
end

# find best k
find_elbow(points, 5, 100)

# k-means
k = 2
N = length(points[:,1])
assignment, reps, J = kmeans(points, k, 100)
groups = [[points[i,:] for i = 1:N if assignment[i] == j] for j = 1:k]
scatter!([c[1] for c in groups[1]], [c[2] for c in groups[1]])
scatter!([c[1] for c in groups[2]], [c[2] for c in groups[2]])
scatter!([c[1] for c in groups[3]], [c[2] for c in groups[3]])

# spectral_clustering
assignment = spectral_clustering(points, k, 100)
groups = [[points[i,:] for i = 1:N if assignment[i] == j] for j = 1:k]
scatter!([c[1] for c in groups[1]], [c[2] for c in groups[1]])
scatter!([c[1] for c in groups[2]], [c[2] for c in groups[2]])
