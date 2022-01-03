using LinearAlgebra

function readArray()
    n = parse(Int, readline())
    A = zeros(n, n)
    for i = 1:n
        v = [parse(Float64, x) for x in split(readline())]
        A[i,:] = v
    end
    return A
end
function create_samples(number_of_samples, bounds)
    points = zeros(number_of_samples, size(bounds)[1])
    for i = 1:number_of_samples
        sample_point = []
        for k = 1:size(bounds)[1]
            push!(sample_point, rand() * bounds[k])
        end
        points[i,:] = sample_point
    end
    return points
end
function get_volume(A, b, sample_ponits, bounds)
    M = 0
    N = size(sample_ponits)[1]
    for i = 1:N
        if all(A * sample_ponits[i,:] .<= b)
            M += 1
        end
    end
    V = 1
    [V *= bounds[i] for i = 1:size(bounds)[1]]
    return V * M / N
end
A = readArray()
b = [parse(Float64, x) for x in split(readline())]
n = size(A)[1]
bounds = []
for i = 1:n
    print(b ./ A[:,i])
    push!(bounds, minimum(b ./ A[:,i]))
end
number_of_samples = 1000
sample_points = create_samples(number_of_samples, bounds)
V = get_volume(A, b, sample_points, bounds)
