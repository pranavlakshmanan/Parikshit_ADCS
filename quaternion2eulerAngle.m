%Quaternion to Euler Angle converter
%Input: 4x1 Quaternion
%Output: 3-2-1 Euler Angles(yaw, pitch, roll)

function [yaw, pitch, roll] = quaternion2eulerAngle(q)
yaw = atan2(2*(q(2, 1) * q(3, 1) + q(1, 1) * q(4, 1))/(q(1, 1) * q(1, 1) + q(2, 1) * q(2, 1) - q(3, 1) * q(3, 1) - q(4, 1) * q(4, 1)), 1);
pitch = asin(2 * (q(1, 1) * q(3, 1) - q(2, 1) * q(4, 1)));
roll = atan2(2*(q(3, 1) * q(4, 1) + q(1, 1) * q(2, 1))/(q(1, 1) * q(1, 1) - q(2, 1) * q(2, 1) - q(3, 1) * q(3, 1) + q(4, 1) * q(4, 1)), 1);
yaw = rad2deg(yaw);
pitch = rad2deg(pitch);
roll = rad2deg(roll);