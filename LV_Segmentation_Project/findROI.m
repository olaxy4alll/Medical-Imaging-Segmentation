function [ROI] = findROI(X, Y, image, folder_name,file_name,image_path,destination)
%it will recieve set of X & Y points in an image and return the bordered
%ROI image
x1 = min(X);
x2 = max(X);
y1 = min(Y);
y2 = max(Y);
height = x2-x1;
width = y2-y1;
ROI = imcrop(image, [x1 y1 height width]);
[m n] = size(image);
%% generate annotation
xml_generator(folder_name,file_name,image_path,int2str(m),int2str(n),int2str(x1),int2str(y1),int2str(x2),int2str(y2),destination);
end