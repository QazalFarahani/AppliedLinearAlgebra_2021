using LinearAlgebra

# a
A = [1 0 0 -1 1;
     0 1 1 0 0;
     1 0 0 1 0]
Ap = [1 0 -1 1;
     0 1 0 0;
     1 0 1 0]
Ap_transpose = transpose(Ap)
C = Ap_transpose * inv(Ap * Ap_transpose)
B = zeros(5, 3)
B[1,:] = C[1,:]
B[3,:] = C[2,:]
B[4,:] = C[3,:]
B[5,:] = C[4,:]
print(A * B)

# d
A_transpose = transpose(A)
B = A_transpose * inv(A * A_transpose)
print(A * B)
