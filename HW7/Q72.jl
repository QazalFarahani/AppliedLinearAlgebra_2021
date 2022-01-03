using LinearAlgebra
using DelimitedFiles
using Plots

data = readdlm("HW7\\data2.txt", ' ')
label = data[:,size(data)[2]]
data = data[:,1:size(data)[2]-1]
split_num = Int(floor(size(data)[1] * 4/5))
train_data = data[1:split_num,:]
train_label = label[1:split_num,:]
test_data = data[split_num+1:end ,:]
test_label = label[split_num+1:end ,:]

function train(data, label)
    m = size(data)[2]
    n = size(data)[1]
    w = zeros(m, 1)
    b = false
    for t = 1:1000
        for i = 1:n
            x = data[i,:]
            if label[i]*dot(w, x) <= 0
                w = w + label[i] * x
                b = true
                break
            end
        end
        if !b
            return w
        end
        b = false
    end
end

function predict(data, w)
    return data * w
end

function get_error(y, prediction)
    s = size(y)[1]
    count = 0
    for i = 1:s
        if y[i] != prediction[i]
            count = count + 1
        end
    end
    return count/s
end

w = train(train_data, train_label)
ŷ = predict(test_data, w)
for i = 1:size(ŷ)[1]
    if ŷ[i] < 0
        ŷ[i] = -1
    else
        ŷ[i] = 1
    end
end

err = get_error(test_label, ŷ)
