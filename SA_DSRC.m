function [ ] = SA_DSRC( DataBase, param )
%% This is a demo of SA_DSRC
lambda = param.lambda;
sparsity = param.sparsity;

tic                                      % Start computing time from here  ��ʼ��ʱ
train = normc(DataBase.training_feats);  % ѵ���������ݹ�һ��
Y = normc(DataBase.testing_feats);              % ��������
W = DataBase.H_train;                    % ѵ��������ǩ
test_label = DataBase.H_test;            % ����������ǩ

Phi = train;                             % ��һ�����ѵ������X
%--------------------------------------------------------------------------
%����M����ʼ
     class_num=40;  %���������
     train_num=3;  %����ÿ��ѵ����
     L=class_num;
     for i=1:class_num
         xi=Phi(:,(i-1)*train_num+1:i*train_num);
         M((i-1)*train_num+1:i*train_num,(i-1)*train_num+1:i*train_num)=xi'*xi;
     end
%����M�������

P = ((1+2*lambda)*Phi' * Phi + 2*lambda*(L-2)*M)\Phi' ;     %���·�����С�������ͶӰ����


  A_check = P * Y;                                        %�����������Y���ܵı�ʾ
  G = Phi'*Phi;                                           %
  A_hat = omp(Phi'*Y,G,sparsity);                         %OMP����һ��
  Score = W * (normc((A_check) + (A_hat)));               %����(A_check) + (A_hat)�����й�һ��

errnum = 0;
Nt = size(Y,2);                       % ѵ����������
for featureid=1:size(Y,2)
    score_est =  Score(:,featureid);
    score_gt = test_label(:,featureid);
    [maxv_est, maxind_est] = max(score_est);  
    [maxv_gt, maxind_gt] = max(score_gt);
    if(maxind_est~=maxind_gt)
        errnum = errnum + 1;
    end
end
accuracy_SACRC = (Nt-errnum)/Nt *100;   %����ѵ���걾ʶ�𾫶�
time_SACRC = toc/Nt;   %�������н���
st = ['Classification accuracy of SA-NDSP is ',  num2str(accuracy_SACRC), '% in ' , num2str(time_SACRC), ' seconds with lambda is  ',num2str(lambda)];
disp (st)     %��ʾ�̶����н��

end




