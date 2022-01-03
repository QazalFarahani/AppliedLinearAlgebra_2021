using LinearAlgebra
using DelimitedFiles
using Plots

data = readdlm("HW8\\data1.txt", ' ')
lamps = data[1:70,:]
lines = data[71:end-1,:]
number_of_lamps = 70
number_of_lines = 50
Ill = data[end,:][1] * ones(number_of_lines, 1)
middle_points = zeros(number_of_lines, 2)
perps = zeros(number_of_lines, 2)
for i = 1:number_of_lines
    middle_points[i,:] = (lines[i,:] + lines[i + 1,:])/2
    vector = lines[i + 1,:] - lines[i,:]
    perps[i,:] = [-vector[2] vector[1]]
end
A = zeros(number_of_lines, number_of_lamps)
for i = 1:number_of_lines
    for j = 1:number_of_lamps
        r = lamps[j,:] - middle_points[i,:]
        cos = dot(r, perps[i,:])/(norm(r) * norm(perps[i,:]))
        A[i, j] = max(cos, 0)/norm(r)^2
    end
end

answer = A\Ill
for i = 1:size(answer)[1]
    if answer[i] > 1
        answer[i] = 1
    elseif answer[i] < 0
        answer[i] = 0
    end
end
print(answer)
