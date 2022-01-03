using LinearAlgebra
using DelimitedFiles
using Plots

data = readdlm("agent-food.txt", ' ')
nlist = []
mlist = []
for i = 1:1843
    push!(mlist, data[i,:][1])
    push!(nlist, data[i,:][2])
end
(m, mc) = findmax(mlist)
(n, nc) = findmax(nlist)
C = zeros(Int(m), Int(n))
for i = 1:1843
    C[Int(data[i,:][1]), Int(data[i,:][2])] = data[i,:][3]
end
i = 58
diff_norm = []
for k = 1:m
    push!(diff_norm, norm(C[Int(k),:] - C[i,:]))
end
finallist = []
for k = 1:11
    (value, index) = findmin(diff_norm)
    push!(finallist, index)
    diff_norm[index] = 22
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
    plot(wss)
end

C = C'
find_elbow(C, 30, 100)
assignment, reps, J = kmeans(C, 28, 100)
groups = [[i for i = 1:300 if assignment[i] == j] for j = 1:28]
print(final)
for i = 1:length(groups)
    print(groups[i])
    println()
end
