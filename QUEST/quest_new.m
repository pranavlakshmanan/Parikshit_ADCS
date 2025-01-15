function q = quest_new(n)
% Initializing arrays for storing the vectors and weights
b_array = [];
r_array = [];
a_array = [];
i = 0;
while i<n %Obtaining user input depending on number of sensors, and calculating unit vectors
    value1 = input("Enter the body frame vector:");
    value1 = value1/norm(value1);
    b_array = [b_array, value1];
    value2 = input("Enter the reference frame vector:");
    value2 = value2/norm(value2);
    r_array = [r_array, value2];
    weight = input("Enter the weight:");
    a_array = [a_array, weight];
    i = i + 1;
end
j1 = 1;
j2 = 1;
siz = size(b_array);
n1 = siz(1, 2);
B = zeros(3,3);
while j1<=n1 && j2<=n %Calculating the B matrix
    B = B + (a_array(j2)*(transpose([b_array(j1) b_array(j1+1) b_array(j1+2)])*[r_array(j1) r_array(j1+1) r_array(j1+2)]));
    j1 = j1 + 3;
    j2 = j2 + 1;
end
%Calculating Z vector
Z = [B(2, 3) - B(3, 2); B(3, 1) - B(1, 3); B(1, 2) - B(2, 1)];
S = B + transpose(B);
sigma = trace(B);
I4 = [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1]; %4x4 identity matrix
I3 = [1 0 0; 0 1 0; 0 0 1]; %3x3 identity matrix
K = [sigma transpose(Z); Z (S - sigma * I3)];
lambda0 = sum(a_array); % Close assumption for eigen value of K matrix
syms lambda;
eq = det(K - lambda*I4) == 0;
eqn = lhs(eq);
dlambda = diff(eqn, lambda);
lambda1 = lambda0 - (subs(eqn, lambda, lambda0)/ subs(dlambda, lambda, lambda0));
while abs(lambda1 - lambda0) > 0.000001 % Newton Raphson method for calculating eigen value
    lambda0 = double(lambda1);
    lambda1 = double(lambda0 - (subs(eqn, lambda, lambda0)/ subs(dlambda, lambda, lambda0)));
end
qr = transpose(Z)*inv((((lambda1 + sigma)*I3) - S)); %Calculating the classical rodrigues parameter
vector = [1 qr];
den = sqrt(1 + (qr)*transpose(qr));
sca = 1/den;
q = sca*vector;% Calculating quaternion from the classical rodrigues parameter
q(1, 1) = double(q(1, 1));
q(1, 2) = double(q(1, 2));
q(1, 3) = double(q(1, 3));
q(1, 4) = double(q(1, 4));
end