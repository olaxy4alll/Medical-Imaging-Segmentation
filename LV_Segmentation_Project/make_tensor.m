clear all
close all
files=dir('segmentedResult/*.jpg')
n=size(files,1)
[h w c]=size(imread(['segmentedResult/' files(4).name]));
It=uint8(zeros(h,w,c,n));
for i=4:n
    I0=imread(['segmentedResult/' files(i).name]);
    It(:,:,:,i)=I0;
    imshow(It(:,:,:,i))
end
figure
I1=imread('00004.jpg');
imshow(I1)
figure
subplot(1,3,1), imshow(It(:,:,1,4))
subplot(1,3,2), imshow(It(:,:,2,4))
subplot(1,3,3), imshow(It(:,:,3,4))
I=size(h,w);
I2=rgb2gray(It(:,:,:,4));
I3=abs(I1-I2);
figure
imshow(I3)
figure
I4=imbinarize(I3);
imshow(I4)