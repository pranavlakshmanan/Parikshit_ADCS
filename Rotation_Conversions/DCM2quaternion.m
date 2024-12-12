%DCM to quaternion convertor
%Input: 3x3 DCM matrix
%Output: 4x1 quaternion

function q = DCM2quaternion(DCM)
qt(1,1) = (1 + trace(DCM))/4;
qt(2,1) = (1 + 2*DCM(2, 2) - trace(DCM))/4;
qt(3,1) = (1 + 2*DCM(1, 1) - trace(DCM))/4;
qt(4,1) = (1 + 2*DCM(3, 3) - trace(DCM))/4;
x = max(qt);
if x == qt(1,1)
    q(1,1) = sqrt(qt(1,1));
    q(2,1) = (DCM(2,3) - DCM(3,2))/(4*q(1,1));
    q(3,1) = (DCM(3,1) - DCM(1,3))/(4*q(1,1));
    q(4,1) = (DCM(1,2) - DCM(2,1))/(4*q(1,1));
elseif x == qt(2,1)
    q(2,1) = sqrt(qt(2,1));
    q(1,1) = (DCM(2,3) - DCM(3,2))/(4*q(2,1));
    q(3,1) = (DCM(1,2) + DCM(2,1))/(4*q(2,1));
    q(4,1) = (DCM(3,1) + DCM(1,3))/(4*q(2,1));
elseif x == qt(3,1)
    q(3,1) = sqrt(qt(3,1));
    q(1,1) = (DCM(3,1) - DCM(1,3))/(4*q(3,1));
    q(2,1) = (DCM(1,2) + DCM(2,1))/(4*q(3,1));
    q(4,1) = (DCM(2,3) + DCM(3,2))/(4*q(3,1));
else
    q(4,1) = sqrt(qt(4,1));
    q(1,1) = (DCM(1,2) - DCM(2,1))/(4*q(4,1));
    q(2,1) = (DCM(3,1) + DCM(1,3))/(4*q(4,1));
    q(3,1) = (DCM(2,3) + DCM(3,2))/(4*q(4,1));
end