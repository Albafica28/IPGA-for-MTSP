function fval = objective(Population, nCity, Dist)
    nPops = size(Population, 1);
    nCars = size(Population, 2) - nCity + 1;
    Fval = zeros(nPops, nCars);
    for i = 1:nPops
        Fval(i, :) = subFun(Population(i, :), nCity, Dist);
    end
    fval = sum(Fval, 2);
end
function mFval = subFun(s, nCity, dist)
    nCars = length(s) - nCity + 1;
    path = s(1:nCity);
    cutPoint = [0, s(nCity+1:end), nCity];
    mFval = zeros(1, nCars);
    for j = 1:nCars
        mPath = path(cutPoint(j)+1:cutPoint(j+1));
        cmDist = dist(sub2ind(size(dist), mPath(1:end-1), mPath(2:end)));
        mFval(j) = sum(cmDist);
    end
end
