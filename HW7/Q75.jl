using LinearAlgebra
using DelimitedFiles

data = readdlm("HW7\\data5.txt", '\t')


function modify_label(label, value)
    n = size(label)[1]
    for i = 1:n
        if label[i] == value
            label[i] = 1
        else
            label[i] = -1
        end
    end
    return label
end


function train(train_data, label, k)
    n = 2*size(train_data)[2]
    theta = zeros(n, k)
    for i = 1:k
        train_label = label[1:split_num,:]
        println(train_label)
        train_label = modify_label(train_label, i)
        println(train_label)
        theta[:,i] = calc_theta(train_data, train_label)
    end
    return theta
end


function classify(predictions)
    n = size(predictions)[1]
    classes = []
    for i = 1:n
        (value, index) = findmax(predictions[i,:])
        push!(classes, index)
    end
    return classes
end


function calc_theta(data, label)
    m = size(data)[1]
    n = size(data)[2]
    A = zeros(m, 2*n)
    [A[i,:] = [ones(n, 1) data[i,:]] for i = 1:m]
    return A\label
end


function predict(data, theta)
    m = size(data)[1]
    n = size(data)[2]
    A = zeros(m, 2*n)
    [A[i,:] = [ones(n, 1) data[i,:]] for i = 1:m]
    return A * theta
end

function get_confusion_matrix(label, prediction, k)
    n = size(label)[1]
    matrix = zeros(k, k)
    for i = 1:n
        if label[i] == 1 && prediction[i] == 1
            matrix[1, 1] = matrix[1, 1] + 1
        elseif label[i] == 2 && prediction[i] == 2
            matrix[2, 2] = matrix[2, 2] + 1
        elseif label[i] == 3 && prediction[i] == 3
            matrix[3, 3] = matrix[3, 3] + 1
        elseif label[i] == 1 && prediction[i] == 2
            matrix[1, 2] = matrix[1, 2] + 1
        elseif label[i] == 2 && prediction[i] == 1
            matrix[2, 1] = matrix[2, 1] + 1
        elseif label[i] == 1 && prediction[i] == 3
            matrix[1, 3] = matrix[1, 3] + 1
        elseif label[i] == 3 && prediction[i] == 1
            matrix[3, 1] = matrix[3, 1] + 1
        elseif label[i] == 3 && prediction[i] == 2
            matrix[3, 2] = matrix[3, 2] + 1
        elseif label[i] == 2 && prediction[i] == 3
            matrix[2, 3] = matrix[2, 3] + 1
        end
    end
    return matrix
end

function get_error(matrix)
    n = size(matrix)[1]
    count = 0
    total = 0
    for i = 1:n
        count = count + matrix[i, i]
        total = total + sum(matrix[i,:])
    end
    print(total)
    print(count)
    return (total - count)/total
end


m = size(data)[1]
n = size(data)[2]
label = data[:,n]
data = data[:,1:n-1]
split_num = Int(floor(m * 4/5))
train_data = data[1:split_num,:]
test_data = data[split_num+1:end,:]
test_label = label[split_num+1:end,:]
k = 3

θ = train(train_data, label, k)
predictions = predict(test_data, θ)
classes = classify(predictions)
confusion_m = get_confusion_matrix(test_label, classes, k)
error = get_error(confusion_m)

predictions = predict(train_data, θ)
classes = classify(predictions)
confusion_m = get_confusion_matrix(train_label, classes, k)
error = get_error(confusion_m)
