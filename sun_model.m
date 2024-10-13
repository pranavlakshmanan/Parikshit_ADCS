function sun_vector = sun_model(year, min, sec)
data = xlsread('twenty_four_hours_per_day.xlsx');
jd = [];
x = [];
y = [];
z = [];
for i = 1:height(data)
    julian_date = juliandate(year,data(i, 2) ,data(i, 1) , data(i, 3), min, sec);
    epoch = 2451545;
    jd = [jd, julian_date - epoch]; %J2000
    m_lon = mod(280.459 + 0.98564736 * (julian_date - epoch), 360); %mean longitude
    m_ano = mod(357.5277233 + 0.98560028 * (julian_date - epoch), 360); %mean anomaly
    ecl_lon = m_lon + 1.914666471*sin(deg2rad(m_ano)) + 0.019994643*sin(deg2rad(2 * m_ano)); %ecliptic longitude
    obl_ecl = 23.439291 - 0.00000036 * (julian_date - epoch); %tilt of Earth's axis
    sun_vector(1, 1) = cos(deg2rad(ecl_lon));
    sun_vector(1, 2) = sin(deg2rad(ecl_lon)) * cos(deg2rad(obl_ecl));
    sun_vector(1, 3) = sin(deg2rad(ecl_lon)) * sin(deg2rad(obl_ecl));
    x = [x, sun_vector(1,1)];
    y = [y, sun_vector(1,2)];
    z = [z, sun_vector(1,3)];
end
hold on;
plot(jd, x);
plot(jd, y);
plot(jd, z);
legend('x component', 'y component', 'z component');
title('Sun Model');
end
