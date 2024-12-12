%3-2-1 Euler Angles to Quaternions converter
%Input: 3-2-1 Euler Angles(yaw, pitch, roll)
%Output: 4x1 Quaternion

function q = eulerAngle2quat(yaw, pitch, roll)
q = zeros(4, 1);
yaw = deg2rad(yaw);
pitch = deg2rad(pitch);
roll = deg2rad(roll);
q(1, 1) = (cos(yaw/2) * cos(pitch/2) * cos(roll/2)) + (sin(yaw/2) * sin(pitch/2) * sin(roll/2));
q(2, 1) = -(sin(yaw/2) * sin(pitch/2) * cos(roll/2)) + (cos(yaw/2) * cos(pitch/2) * sin(roll/2));
q(3, 1) = (cos(yaw/2) * sin(pitch/2) * cos(roll/2)) + (sin(yaw/2) * cos(pitch/2) * sin(roll/2));
q(4, 1) = (sin(yaw/2) * cos(pitch/2) * cos(roll/2)) - (cos(yaw/2) * sin(pitch/2) * sin(roll/2));