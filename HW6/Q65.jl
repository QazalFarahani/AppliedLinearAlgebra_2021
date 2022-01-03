using LinearAlgebra
using DelimitedFiles
using Plots

data = readdlm("data2.txt", ',')
label = data[:,3]
data = data'[setdiff(1:end, 3), :]'

function has_converge(w, label, data)
    prediction = data * w
    for i = 1:length(prediction)
        if prediction[i] < 0
            prediction[i] = -1
        else
            prediction[i] = 1
        end
    end
    return prediction == label
end

data_train = data[1:160,:]
data_test = data[161:end,:]
label_train = label[1:160,:]
label_test = label[161:end,:]

function perceptron(data_train, label_train)
    w = data_train[1,:]
    for j = 1:100
        if has_converge(w, label_train, data_train)
            break
        end
        for i = 1:length(label_train)
            x = data_train[i,:]
            y = label[i]
            ŷ = dot(x, w)/norm(dot(x, w))
            if y != label_train[i]
                w = w + y * x
            end
        end
    end
    return w
end

function winnow(data_train, label_train, u)
    w = ones(length(data[1,:]))/length(data[1,:])
    for j = 1:400
        if has_converge(w, label_train, data_train)
            break
        end
        for i = 1:length(label_train)
            x = data_train[i,:]
            y = label[i]
            ŷ = dot(x, w)/norm(dot(x, w))
            if y != label_train[i]
                for k = 1:length(w)
                    w[i] = w[i] * exp(u * y * x)
                end
                w = w / sum(w)
            end
        end
    end
    return w
end

function predict(data_test, label_test, w, t)
    prediction = zeros(length(label_test), 1)
    for i = 1:length(label_test)
        ŷ = w' * data_test[i,:]
        if ŷ < t
            prediction[i] = -1
        else
            prediction[i] = 1
        end
    end
    return prediction
end

function plot_data(data_test, prediction)
    groups = [[data_test[i,:] for i = 1:length(data_test[:,1]) if prediction[i] == j] for j in [1 -1]]
    scatter!([c[1] for c in groups[1]], [c[2] for c in groups[1]])
    scatter!([c[1] for c in groups[2]], [c[2] for c in groups[2]])
end

scatter(data[:,1], data[:,2])

w = perceptron(data_train, label_train)
prediction = predict(data_test, label_test, w, 0)
plot_data(data_test, prediction)

w = winnow(data_train, label_train, 1)
prediction = predict(data_test, label_test, w, 1)
plot_data(data_test, prediction)
