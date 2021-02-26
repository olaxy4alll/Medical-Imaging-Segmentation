clc
close all
clear all

base_address = 'E:\MSCV2_Final_Docs\medical\project\cnn_project\medical_final_project\training\';

specific_address = 'patient001\patient001_4d.nii';
% specific_address = 'patient010\patient010_4d.nii\CMD_17.nii';
% specific_address = 'patient010\patient010_frame01.nii\17Gate0.nii';
% specific_address = 'patient010\patient010_frame13.nii\17Gate12.nii';
V=load_nii(strcat(base_address , specific_address));
for i=1:10
    Iroi= V.img(:,:,i,1);
%   subplot(2,5,i),imshow(uint8(Iroi))
    imshow(uint8(Iroi));
%     imwrite(uint8(V.img(:,:,i,1)),['patient_jpg/test_image/' '000' int2str(i+140) '.jpg'])
end
% figure
% j=0
% for i=[3,7,10]
%     j=j+1;
%     Iroi= V.img(:,:,i,1);
%     subplot(1,3,j),imshow(uint8(Iroi))
%     axis off
% end
