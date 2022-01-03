function mFval = subFun(sPopulation, nCity, dist)
    mPath = cut(sPopulation, nCity);
    nCars = length(sPopulation) - nCity + 1;
    mFval = zeros(1, nCars);
    for j = 1:nCars
        if length(mPath{j}) < 2
            mFval(j) = 0;
        else
            indp = mPath{j}(:,1:end-1);
            endp = mPath{j}(:,2:end);
            cmDist = dist(sub2ind(size(dist), indp, endp));
            mFval(j) = sum(cmDist);
        end
    end
end