function [bestPop, bestFval, minFval] = ga_mTSP(objective, nVars, nCity, opts)
%{ 
     This project developed a genetic algorithm package to solve the 
     MTSP based on the IPGA proposed by Zhou et al.(2018).
     INPUT: 
       objective: 目标函数，输入值仅为种群，输出值仅为目标函数值
       nVars：个体长度=城市数量+旅行者数量-1
       nCity：城市数量
       opts：优化参数选项设定，部分缺省时由默认参数选项def代替
     OUTPUT: 
       bestPop: 最优个体
       bestFval: 最优个体对应的目标函数值
       minFval: 每一代的最优函数值
     References: 
       Zhou, H., Song, M., & Pedrycz, W. (2018). A comparative study of 
       improved GA and PSO in solving multiple traveling salesmen problem. 
       Applied Soft Computing, 64, 564-580.
    Author: https://github.com/Albafica28/IPGA-for-MTSP.git 
%}
    
    def.FunctionTolerance = 1e-10;
    def.MaxFunctionEvaluations = inf;
    def.MaxGenerations = inf;
    def.MaxStallGenerations = 50*ceil(log(nVars));
    def.PopulationSize = 100*ceil(nVars/10);
    def.Display = "on";
    if nargin < 4
        opts = struct();
    end
    customized = fieldnames(opts);
    for i = 1:numel(customized)
        if ~isfield(def,customized{i})
            error('输入的options中有不能识别的项目%s。',customized{i});
        end
        def.(customized{i}) = opts.(customized{i});
    end
    opts = def; stalls = 0; iter = 1;
    Population = my_Create(opts.PopulationSize, nVars, nCity);
    minFval = objective(Population(1, :));
    while true
        fval = objective(Population); % 计算种群适应度
        fcount = iter*opts.PopulationSize;
        iter = iter + 1;
        [fval, idx] = sort(fval);
        minFval(iter) = fval(1);
        bestPop = Population(1, :);
        Population = Population(idx, :);
        if minFval(iter) < minFval(iter-1) - opts.FunctionTolerance
            stalls = 0;
        else
            stalls = stalls + 1;
        end
        if opts.Display == "on"
            display(iter-1, fcount, minFval(iter), fval, stalls)
        end
        if (stalls > opts.MaxStallGenerations) || ...
           (iter > opts.MaxGenerations) || ...
           (fcount > opts.MaxFunctionEvaluations)
            break % 终止条件
        end
        pMean = stalls./opts.MaxStallGenerations;
        idx = reshape(1:opts.PopulationSize, opts.PopulationSize/10, 10);
        for i = 1:opts.PopulationSize/10
            Population(idx(i, :), :) = IPGA(Population(idx(i, :), :), nCity, pMean);
        end
    end
    bestFval = minFval(iter);
end

function new_X = my_Create(nPop, nVars, nCity) % 初始化种群函数 
    new_X = zeros(nPop, nVars);
    nCars = nVars - nCity;
    for i = 1:nPop
        new_X(i, 1:nCity) = randperm(nCity);
        new_X(i, nCity+1:nVars) = sort(randperm(nCity, nCars));
        new_X(i, nCity+1:nVars) = max(2:nCars+1, new_X(i, nCity+1:nVars));
        new_X(i, nCity+1:nVars) = min(nCity-nCars:nCity-1, new_X(i, nCity+1:nVars));
    end
end

function s = IPGA(s, nCity, pMean)
    SegmentP = sort(randperm(nCity, 2));
    nVars = length(s);
    for k = 2:5
        s(k, :) = crossover(s(1, :), k-1);
    end
    for k = 6:10
        s(k, :) = variation(s(k-5, :));
    end
    function s = crossover(s, Rand) % 交叉函数
        switch Rand
            case 1 % FlipInsert
                s(SegmentP(1):SegmentP(2)) = s(SegmentP(2):-1:SegmentP(1));
            case 2 % SwapInsert
                s(SegmentP) = s(sort(SegmentP, 'descend'));
            case 3 % LSliInsert
                SegmentP = max([2, 3; SegmentP]);
                s1 = s(SegmentP(1)-1:SegmentP(2)-1);
                s2 = s([1:SegmentP(1)-2, SegmentP(2):nVars]);
                s(SegmentP(1):SegmentP(2)) = s1;
                s([1:SegmentP(1)-1, SegmentP(2)+1:nVars]) = s2;
            case 4 % RSliInsert
                SegmentP = min([nCity-2, nCity-1; SegmentP]);
                s1 = s(SegmentP(1)+1:SegmentP(2)+1);
                s2 = s([1:SegmentP(1), SegmentP(2)+2:nVars]);
                s(SegmentP(1):SegmentP(2)) = s1;
                s([1:SegmentP(1)-1, SegmentP(2)+1:nVars]) = s2;
            otherwise
                s(SegmentP(1):SegmentP(2)) = s(SegmentP(2):-1:SegmentP(1));
        end
    end    
    function s = variation(s) % 变异函数
        nCars = nVars - nCity;
        if rand > pMean
            s(nCity+1:end) = sort(randperm(nCity, nCars));
        else % 保证切割点位于中间
            nPoints = rand(1, nCars+1);
            nPoints = cumsum(round(nCity*(1+nPoints)./sum(1+nPoints)));
            s(nCity+1:end) = nPoints(1:end-1);
        end
        s(nCity+1:end) = max(2:nCars+1, s(nCity+1:end));
        s(nCity+1:end) = min(nCity-nCars:nCity-1, s(nCity+1:end));
    end
end

function display(gen, fcount, best, fval, stall)
    if mod(gen, 30) == 1
        disp('                                  Best           Mean      Stall');
        disp('Generation      Func-count        f(x)           f(x)    Generations');
    end
    fprintf('%5d     %12d    %12g    %12g    %5d\n',gen,fcount,best,nanmean(fval),stall);
end
