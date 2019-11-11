clc
close all

I = imread('C:\Users\MAHMUD\Google Drive\cancer detection\NewImages\images2.jpg');
%I = imread('C:\Users\MAHMUD\Google Drive\cancer detection\10.png');
figure, imshow(I);

%gray scale conversion an filtaring
I = rgb2gray(I);

%I = histeq(I);
Ig = I;
I = medfilt2(I);
figure, imshow(I);

%contrust adjustment to remove regions colse to dark
I = imadjust(I, [40, 250]/255, [20, 255]/255);
figure, imshow(I);

%BW conversion using
%BWs = imbinarize(I,0.43);
%(sum(I(:))/nnz(I(:)))/100

BWs = imbinarize(I,0.87);

figure
imshow(BWs)

%filling gaps of bounded objects
figure
BWdfill = imfill(BWs,'holes');
imshow(BWdfill)


figure
BWnoborder = imclearborder(BWdfill,4);
imshow(BWnoborder)

BWfinal = BWnoborder;
%BWfinal = bwmorph(BWnoborder,'shrink');
% seD = strel('diamond',1);
% BWfinal = imerode(BWfinal,seD);


%%%%%%%Finding Regions With Ranged Area%%%%%%%%
CC = bwconncomp(BWfinal);
S = regionprops(CC, 'Area');
L = labelmatrix(CC);

%find MAX ROI after border object removal
BWfinal = ismember(L, find([S.Area] == max([S.Area]) ));

%find ROI using Range
% BWfinal = ismember(L, find([S.Area] > 50 & [S.Area] < 500 ));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%segmented result
figure
imshow(BWfinal)

%marking image with red overlay
marked = labeloverlay(Ig,BWfinal,'Colormap',[1 0 0] ,'Transparency',0.5);

%mark image
figure
imshow(marked)

figure 
imshowpair(Ig,marked,'montage');
