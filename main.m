clc
clear
close all

% 随机生成数据
rng 'default'
nCity = 30;
nCars = 3;
nVars = nCity + nCars - 1;
rangeX = [-85.085, -84.607];
rangeY = [ 43.467,  43.815];
[CityCoor, Dist] = data_Generate(nCity, rangeX, rangeY);

% 优化过程
tic
fun = @(Population)objective(Population, nCity, Dist);
[bestPop, bestFval, minFval] = ga_mTSP(fun, nVars, nCity);
path = bestPop(1:nCity);
cutPoint = [0, bestPop(nCity+1:end), nCity];
time = toc;

% 最终结果可视化
figure('Position', [10, 60, 1000, 500])
subplot(121);
plot(minFval, 'LineWidth', 1), grid on
xlabel('迭代次数'), ylabel('目标函数')
legend('IPGA')
title("time = "+num2str(time,'%1.2f')+"sec, iter = "+num2str(length(minFval),'%1.0f'))
set(gca,'FontSize', 15, 'OuterPosition', [0.01 0.05 0.47 0.9;]);
subplot(122)
lgdStr = cell(1, nCars);
for k = 1:nCars
    mPath = path(cutPoint(k)+1:cutPoint(k+1));
    x_Location = CityCoor([mPath, mPath(1)], 2);
    y_Location = CityCoor([mPath, mPath(1)], 1);
    plot(x_Location, y_Location, '-o'); hold on
    lgdStr{k} = "Car "+num2str(k);
end
grid on
legend(lgdStr, 'Location', 'SW')
title("minDist = "+num2str(bestFval, '%1.4f'))
set(gca,'FontSize', 15, 'OuterPosition', [0.51 0.05 0.47 0.9;]);


