clear all 
close all
clc

addpath ./OMPbox              % 将OMPbox添加到路径
data = load('DataBase.mat');  % load the provided data   AR.mat        DataBase(YaleB)  
DataBase = data.DataBase;     % DataBase = data.DataBase; 
param.lambda =0.0001;        
param.sparsity =28;          % 28
SA_DSRC(DataBase, param);    