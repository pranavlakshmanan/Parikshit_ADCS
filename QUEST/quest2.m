function q = quest2(b10, r10, b20, r20, a1, a2)
% Calculating the unit vectors from the input vectors
b1 = b10/norm(b10);
b2 = b20/norm(b20);
r1 = r10/norm(r10);
r2 = r20/norm(r20);
B = a1*(transpose(b1)*r1) + a2*(transpose(b2)*r2); %Calculating B matrix - to be used later
S = B + transpose(B);
sigma = trace(B);
I3 = [1 0 0;0 1 0;0 0 1]; % 3x3 identity matrix
I4 = [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1]; %4x4 identity matrix
Z = [B(2, 3) - B(3, 2); B(3, 1) - B(1, 3); B(1, 2) - B(2, 1)];
K = [sigma transpose(Z); Z (S - sigma * I3)];
lambda0 = a1 + a2;
syms lambda;
eq = det(K - lambda*I4) == 0;
eqn = lhs(eq);
dlambda = diff(eqn, lambda);
lambda1 = lambda0 - (subs(eqn, lambda, lambda0)/ subs(dlambda, lambda, lambda0));
while abs(lambda1 - lambda0) > 0.000001 % NR method for calculating eigen value
    lambda0 = double(lambda1);
    lambda1 = double(lambda0 - (subs(eqn, lambda, lambda0)/ subs(dlambda, lambda, lambda0)));
end
qr = transpose(Z)*inv((((lambda1 + sigma)*I3) - S)); %Calculating the classical rodrigues parameter
vector = [1 qr];
den = sqrt(1 + (qr)*transpose(qr));
sca = 1/den;
q = sca*vector; % Calculating quaternion from the classical rodrigues parameter
q(1, 1) = double(q(1, 1));
q(1, 2) = double(q(1, 2));
q(1, 3) = double(q(1, 3));
q(1, 4) = double(q(1, 4));
end