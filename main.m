% HS（Harmony Search Algorithm）算法 -- 和声搜索算法
% web('halcom.cn')
% ysw
clc,clear,close all % 清理命令区、清理工作区、关闭显示图形
warning off         % 消除警告
feature jit off     % 加速代码运行
format short        % 数据类型
tic                 % 运算计时
global nVar
%% HS算法参数初始化
nVar=2;             % 待求变量个数
popmin = [-5, -5]; % 最小取值
popmax = [5, 5];   % 最大取值
% HMS = 100;      % 和声记忆库大小(即种群数量)
sizepop = 100;      % 和声记忆库大小(即种群数量)
bw=0.2;         % 音调微调扰动带宽
HMCR=0.75;      % 和声记忆库保留概率Harmony Memory Considering Rate
PAR=0.2;        % 基音调整概率Pitch Adjustment Ra
maxiter=10000;  % 最大迭代次数
%% 初始化种群
for i=1:sizepop
    pop(i,:) = popmin + (popmax-popmin).*rand(1,nVar);
    fitness(i) = fun( pop(i,:) );
end
% 记录一组最优值
% [bestFit,bestLoc]=max(fitness);     % 初始化最优适应度值
[bestfitness,bestLoc]=min(fitness);     % 初始化最优适应度值
zbest=pop(bestLoc,:);                   % 全局最佳

% 迭代寻优
for iter = 1:maxiter
   
    Harmony =[];
    % 个体位置更新
    HarmonyIndex=fix(rand(1,nVar)*sizepop)+1;   % 随机的选取两个个体对应的矩阵标号
    Harmony=diag(pop(HarmonyIndex,1:nVar))'; % 提取对角元素值
    CMMask=rand(1,nVar)<HMCR;
    NHMask=(1-CMMask);
    PAMask=(rand(1,nVar)<PAR).*(CMMask);
    CMMask=CMMask.*(1-PAMask);
    NewHarmony=[];
    NewHarmony=CMMask.*Harmony+PAMask.*(Harmony+bw*(2*rand(1,nVar)-1))+NHMask.*(popmin+(popmax-popmin).*rand(1,nVar));
    % 个体取值范围约束
    OutOfBoundry=[];
    OutOfBoundry=(NewHarmony>popmax)+(NewHarmony<popmin);
    NewHarmony(OutOfBoundry==1)=Harmony(OutOfBoundry==1);
   
    % 适应度更新
    NHF=fun(NewHarmony); % 适应度更新
   
    % 种群最优个体更新
    if (NHF<bestfitness)       % 如果适应度值更好，则保留
        pop(bestLoc,:)=NewHarmony;           % 个体更新
        fitness(bestLoc)=NHF;               % 个体适应度值更新
%         [bestfitness,bestLoc]=min(fitness); % 最优个体适应度值即下标
        bestfitness = NHF;                  % 最优个体适应度值即下标
        zbest = NewHarmony;                 % 个体更新
    end
   
    fitness_iter(iter) = bestfitness;       % 保存每一次迭代中的最优适应度值
end

disp('最优解')
disp(zbest)
fprintf('\n')

% figure('color',[1,1,1])
% plot(fitness_iter,'ro-','linewidth',2)

figure('color',[1,1,1])
loglog(fitness_iter,'ro-','linewidth',2)