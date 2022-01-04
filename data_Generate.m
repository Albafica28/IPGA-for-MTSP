function [CityCoor, Dist] = data_Generate(nCity, rangeX, rangeY)
    CityCoor(:, 1) = unifrnd(rangeX(1), rangeX(2), nCity, 1);
    CityCoor(:, 2) = unifrnd(rangeY(1), rangeY(2), nCity, 1);
    Dist = zeros(nCity, nCity);
    for i = 1:nCity  % 地点之间的距离
        Dist(:, i) = dis(CityCoor(i, :), CityCoor);
    end
end
function distance = dis(location1, location2) % 一组点和一个点之间的近似地理距离
    r = 6370996.81/100000; % 地球半径
    db = (location1(:,2) + location2(:,2))/2;
    dx = (location1(:,1) - location2(:,1)).*cos(db);
    dy = (location1(:,2) - location2(:,2)); 
    distance = r*sqrt(dx.^2+dy.^2);
end