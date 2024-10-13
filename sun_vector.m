function sun_vector = sun_vector(year, month, day, hr, min, sec)
    julian_date = juliandate(year, month ,day , hr, min, sec);
    epoch = 2451545;
    m_lon = mod(280.459 + 0.98564736 * (julian_date - epoch), 360); %mean longitude
    m_ano = mod(357.5277233 + 0.98560028 * (julian_date - epoch), 360); %mean anomaly
    ecl_lon = m_lon + 1.914666471*sin(deg2rad(m_ano)) + 0.019994643*sin(deg2rad(2 * m_ano)); %ecliptic longitude
    obl_ecl = 23.439291 - 0.00000036 * (julian_date - epoch); %tilt of Earth's axis
    sun_vector(1, 1) = cos(deg2rad(ecl_lon));
    sun_vector(1, 2) = sin(deg2rad(ecl_lon)) * cos(deg2rad(obl_ecl));
    sun_vector(1, 3) = sin(deg2rad(ecl_lon)) * sin(deg2rad(obl_ecl));
end
