%Quaternion to DCM converter
%Input: 4x1 Quaternion
%Output: 3x3 DCM Matrix
function DCM = quaternion2DCM(q)
DCM = zeros(3,3);
DCM(1, 1) = q(1,1)*q(1,1) + q(2,1)*q(2,1) - q(3,1)*q(3,1) - q(4,1)*q(4,1);
DCM(1, 2) = 2*((q(2, 1) * q(3, 1)) + (q(1, 1) * q(4, 1)));
DCM(1, 3) = 2*((q(2, 1) * q(4, 1)) - (q(1, 1) * q(3, 1)));
DCM(2, 1) = 2*((q(2, 1) * q(3, 1)) - (q(1, 1) * q(4, 1)));
DCM(2, 2) = q(1,1)*q(1,1) - q(2,1)*q(2,1) + q(3,1)*q(3,1) - q(4,1)*q(4,1);
DCM(2, 3) = 2*((q(3, 1) * q(4, 1)) + (q(1, 1) * q(2, 1)));
DCM(3, 1) = 2*((q(2, 1) * q(4, 1)) + (q(1, 1) * q(3, 1)));
DCM(3, 2) = 2*((q(3, 1) * q(4, 1)) - (q(1, 1) * q(2, 1)));
DCM(3, 3) = q(1,1)*q(1,1) - q(2,1)*q(2,1) - q(3,1)*q(3,1) + q(4,1)*q(4,1);