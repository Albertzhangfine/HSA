% HS��Harmony Search Algorithm���㷨 -- ���������㷨
% web('halcom.cn')
% ysw
clc,clear,close all % �����������������������ر���ʾͼ��
warning off         % ��������
feature jit off     % ���ٴ�������
format short        % ��������
tic                 % �����ʱ
global nVar
%% HS�㷨������ʼ��
nVar=2;             % �����������
popmin = [-5, -5]; % ��Сȡֵ
popmax = [5, 5];   % ���ȡֵ
% HMS = 100;      % ����������С(����Ⱥ����)
sizepop = 100;      % ����������С(����Ⱥ����)
bw=0.2;         % ����΢���Ŷ�����
HMCR=0.75;      % ��������Ᵽ������Harmony Memory Considering Rate
PAR=0.2;        % ������������Pitch Adjustment Ra
maxiter=10000;  % ����������
%% ��ʼ����Ⱥ
for i=1:sizepop
    pop(i,:) = popmin + (popmax-popmin).*rand(1,nVar);
    fitness(i) = fun( pop(i,:) );
end
% ��¼һ������ֵ
% [bestFit,bestLoc]=max(fitness);     % ��ʼ��������Ӧ��ֵ
[bestfitness,bestLoc]=min(fitness);     % ��ʼ��������Ӧ��ֵ
zbest=pop(bestLoc,:);                   % ȫ�����

% ����Ѱ��
for iter = 1:maxiter
   
    Harmony =[];
    % ����λ�ø���
    HarmonyIndex=fix(rand(1,nVar)*sizepop)+1;   % �����ѡȡ���������Ӧ�ľ�����
    Harmony=diag(pop(HarmonyIndex,1:nVar))'; % ��ȡ�Խ�Ԫ��ֵ
    CMMask=rand(1,nVar)<HMCR;
    NHMask=(1-CMMask);
    PAMask=(rand(1,nVar)<PAR).*(CMMask);
    CMMask=CMMask.*(1-PAMask);
    NewHarmony=[];
    NewHarmony=CMMask.*Harmony+PAMask.*(Harmony+bw*(2*rand(1,nVar)-1))+NHMask.*(popmin+(popmax-popmin).*rand(1,nVar));
    % ����ȡֵ��ΧԼ��
    OutOfBoundry=[];
    OutOfBoundry=(NewHarmony>popmax)+(NewHarmony<popmin);
    NewHarmony(OutOfBoundry==1)=Harmony(OutOfBoundry==1);
   
    % ��Ӧ�ȸ���
    NHF=fun(NewHarmony); % ��Ӧ�ȸ���
   
    % ��Ⱥ���Ÿ������
    if (NHF<bestfitness)       % �����Ӧ��ֵ���ã�����
        pop(bestLoc,:)=NewHarmony;           % �������
        fitness(bestLoc)=NHF;               % ������Ӧ��ֵ����
%         [bestfitness,bestLoc]=min(fitness); % ���Ÿ�����Ӧ��ֵ���±�
        bestfitness = NHF;                  % ���Ÿ�����Ӧ��ֵ���±�
        zbest = NewHarmony;                 % �������
    end
   
    fitness_iter(iter) = bestfitness;       % ����ÿһ�ε����е�������Ӧ��ֵ
end

disp('���Ž�')
disp(zbest)
fprintf('\n')

% figure('color',[1,1,1])
% plot(fitness_iter,'ro-','linewidth',2)

figure('color',[1,1,1])
loglog(fitness_iter,'ro-','linewidth',2)