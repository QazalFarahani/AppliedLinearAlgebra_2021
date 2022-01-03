using LinearAlgebra

n = parse(Int, readline())
c = [parse(Float64, x) for x in split(readline())]
b = parse(Float64, readline())
p_1 = [parse(Float64, x) for x in split(readline())]
p_2 = [parse(Float64, x) for x in split(readline())]
epsilon = 1.0e-10

function reflection(n, c, b, p_1)
    w = (dot(c, p_1) / (norm(c)^2)) * c
    v = zeros(1, n)
    for i = 1:n
        if abs(c[i]) > epsilon
            v[i] = b / c[i]
            break
        end
    end
    v = (dot(v, c) / (norm(c)^2)) * c
    p_prm = p_1 + 2 * (v - w)
    return p_prm
end

function find_q(n, c, b, p_1, p_2)
    v = zeros(1, n)
    for i = 1:n
        if abs(c[i]) > epsilon
            v[i] = b / c[i]
            break
        end
    end
    d_1 = (dot((p_1 - transpose(v)), c) / (norm(c)^2)) * c
    d_2 = (dot((p_2 - transpose(v)), c) / (norm(c)^2)) * c
    proj_1 = p_1 - d_1
    proj_2 = p_2 - d_2
    norm_d_1 = norm(d_1)
    norm_d_2 = norm(d_2)
    if norm_d_1 < epsilon && norm_d_2 < epsilon
        return p_1
    end
    if dot(d_1, d_2) > epsilon
        p_2 = reflection(n, c, b, p_2)
    end
    diff = p_2 - p_1
    q = p_2 - diff * (norm_d_2 / (norm_d_1 + norm_d_2))
    return q
end


p_prm = reflection(n, c, b, p_1)
q = find_q(n, c, b, p_1, p_2)
[print(x, " ") for x in p_prm]
println()
[print(x, " ") for x in q]
