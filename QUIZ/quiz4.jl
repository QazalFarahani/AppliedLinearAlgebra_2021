using LinearAlgebra
using DelimitedFiles

Data = readdlm("dataset1.txt",'\t')
label = Data[:,7]
D = Data'[setdiff(1:end, 7), :]'
A = [ones(303) D]

function avg(v)
    return sum(v)/length(v)
end

function std(v)
    norm(v - (avg(v) * ones(length(v))) / sqrt(length(v)))
end

Data_normalized = zeros(303, 6)
for i = 1:6
    Data_normalized[:,i] = (D[:,i] - (avg(D[:,i]) * ones(length(D[:,i])))) / std(D[:,i])
end

A_normalized = zeros(303, 7)
for i in [2 5 6]
    A_normalized[:,i] = (A[:,i] - (avg(A[:,i]) * ones(length(A[:,i])))) / std(A[:,i])
end
for i in [1 3 4 7]
    A_normalized[:,i] = A[:,i]
end

Ntrain = 242
NTest = 61
train_data = A[1:242,:]
train_label = label[1:242,:]
test_data = A[243:end ,:]
test_label = label[243:end ,:]
train_data_normalized = A_normalized[1:242,:]
test_data_normalized = A_normalized[243:end ,:]

theta = pinv(train_data) * train_label
theta_normalized = pinv(train_data_normalized) * train_label

function get_ftilde(A,theta)
    return A*theta
end

function get_fhat(A,theta ,alpha)
    f̃ = get_ftilde(A, theta)
    f̂ = zeros(length(f̃))
    for i = 1:length(f̃)
        if f̃[i] >= alpha
            f̂[i] = 1
        else
            f̂[i] = -1
        end
    end
    return f̂
end

alpha = 0
test_prediction = get_fhat(A, theta, alpha)
test_prediction_normalized = get_fhat(A_normalized, theta_normalized, alpha)

function Ntp(label ,prediction)
    count = 0
    for i = 1:length(label)
        if label[i] == 1 && prediction[i] == 1
            count = count + 1
        end
    end
    return count
end

function Ntn(label ,prediction)
    count = 0
    for i = 1:length(label)
        if label[i] == -1 && prediction[i] == -1
            count = count + 1
        end
    end
    return count
end

function Nfp(label ,prediction)
    count = 0
    for i = 1:length(label)
        if label[i] == -1 && prediction[i] == 1
            count = count + 1
        end
    end
    return count
end

function Nfn(label ,prediction)
    count = 0
    for i = 1:length(label)
        if label[i] == 1 && prediction[i] == -1
            count = count + 1
        end
    end
    return count
end

function error_rate(label ,prediction)
    tp = Ntp(label, prediction)
    tn = Ntn(label, prediction)
    fp = Nfp(label, prediction)
    fn = Nfn(label, prediction)
    return (fp + fn) / (fp + fn + tp + tn)
end

function true_positive_rate(label ,prediction)
    return Ntp(label, prediction)/(Ntp(label, prediction) + Nfn(label, prediction))
end

function false_positive_rate(label ,prediction)
    return Nfp(label, prediction)/(Nfp(label, prediction) +  Ntn(label, prediction))
end

function confusion_matrix(label ,prediction)
    A = zeros(2, 2)
    A[1, 1] = Ntp(label, prediction)
    A[1, 2] = Nfn(label, prediction)
    A[2, 1] = Nfp(label, prediction)
    A[2, 2] = Ntn(label, prediction)
    return A
end

error = error_rate(label, test_prediction)
error_normalized = error_rate(label, test_prediction_normalized)
confusion_m = confusion_matrix(label, test_prediction)
confusion_m_n = confusion_matrix(label, test_prediction_normalized)

function func1(alpha)
    # p = get_fhat(A, theta, alpha)
    p_n = get_fhat(A_normalized, theta_normalized, alpha)
    # return true_positive_rate(label, p)
    return true_positive_rate(label, p_n)
end

function func2(alpha)
    # p = get_fhat(A, theta, alpha)
    p_n = get_fhat(A_normalized, theta_normalized, alpha)
    # return false_positive_rate(label, p)
    return false_positive_rate(label, p_n)
end

plot([func1, func2] , -2 , 2 , title = "normalized")



pred_train = train_p[1:242,:]
pred_test = test_prediction[243:end ,:]
