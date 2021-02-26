 
clc
clear all
close all
%% generate annotation

%% generate mask

%% train network
command_train_network = 'python network_training_LV.py 1';
display('python function in progress...')
[status_test, commandOut_test] = system(command_train_network,'-echo')
if status_test==0
    fprintf('squared result is %d\n',str2num(commandOut_test));
end

% %% evaluation
% commandpython_eval = 'python Mask_RCNN_segmentation.py 1';
% display('python function in progress...')
% [status_eval, commandOut_eval] = system(commandpython_eval,'-echo')
% if status_eval==0
%     fprintf('squared result is %d\n',str2num(commandOut_eval));
% end