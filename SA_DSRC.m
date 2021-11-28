function [ ] = SA_DSRC( DataBase, param )
%% This is a demo of SA_DSRC
lambda = param.lambda;
sparsity = param.sparsity;

tic                                      % Start computing time from here  开始计时
train = normc(DataBase.training_feats);  % 训练样本数据归一化
Y = normc(DataBase.testing_feats);              % 测试样本
W = DataBase.H_train;                    % 训练样本标签
test_label = DataBase.H_test;            % 测试样本标签

Phi = train;                             % 归一化后的训练样本X
%--------------------------------------------------------------------------
%计算M矩阵开始
     class_num=40;  %设置类别数
     train_num=3;  %设置每类训练数
     L=class_num;
     for i=1:class_num
         xi=Phi(:,(i-1)*train_num+1:i*train_num);
         M((i-1)*train_num+1:i*train_num,(i-1)*train_num+1:i*train_num)=xi'*xi;
     end
%计算M矩阵结束

P = ((1+2*lambda)*Phi' * Phi + 2*lambda*(L-2)*M)\Phi' ;     %徐勇方法最小二乘求得投影矩阵。


  A_check = P * Y;                                        %计算测试样本Y稠密的表示
  G = Phi'*Phi;                                           %
  A_hat = omp(Phi'*Y,G,sparsity);                         %OMP计算一个
  Score = W * (normc((A_check) + (A_hat)));               %计算(A_check) + (A_hat)并进行归一化

errnum = 0;
Nt = size(Y,2);                       % 训练样本个数
for featureid=1:size(Y,2)
    score_est =  Score(:,featureid);
    score_gt = test_label(:,featureid);
    [maxv_est, maxind_est] = max(score_est);  
    [maxv_gt, maxind_gt] = max(score_gt);
    if(maxind_est~=maxind_gt)
        errnum = errnum + 1;
    end
end
accuracy_SACRC = (Nt-errnum)/Nt *100;   %计算训练标本识别精度
time_SACRC = toc/Nt;   %程序运行结束
st = ['Classification accuracy of SA-NDSP is ',  num2str(accuracy_SACRC), '% in ' , num2str(time_SACRC), ' seconds with lambda is  ',num2str(lambda)];
disp (st)     %显示程度运行结果

end




