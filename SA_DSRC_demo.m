clear all 
close all
clc

addpath ./OMPbox           
data = load('DataBase.mat'); 
DataBase = data.DataBase;   
param.lambda =0.0001;        
param.sparsity =28;         
SA_DSRC(DataBase, param);    
