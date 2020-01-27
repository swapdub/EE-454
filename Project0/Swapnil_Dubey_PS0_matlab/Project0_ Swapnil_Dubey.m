clc
clear

% EE 454 - Swapnil Dubey Spring 2020

BS = imread('./data/banana_slug.tiff');

imwrite(BS, 'banana_slug.tiff');

[Ysize, Xsize] = size(BS);   % Ysize = 2856, Xsize = 4290

class(BS); %Class = unint 16 = 16 bit unsigned integer array

BS = double(BS);

nBS = (BS - 2047)/(15000-2047); %normalize 0-1

nBS = max(0,min(nBS, 1)); %cut off between 0-1

im1 = nBS(1:2:end, 1:2:end); %red
im2 = nBS(1:2:end, 2:2:end); %green
im3 = nBS(2:2:end, 1:2:end); %Green
im4 = nBS(2:2:end, 2:2:end); %blue

p_grbg = cat(3,im2,im1,im4);
p_rggb = cat(3,im1,im2,im4);
p_bggr = cat(3,im4,im2,im1);
p_gbrg = cat(3,im2,im4,im1);

figure; imshow(p_grbg);
figure; imshow(p_rggb);
figure; imshow(p_bggr);
figure; imshow(p_gbrg);

%Fig 3 looks good: bggr
red = im1;
green1 = im2;
green2 = im3;
blue = im4;

red_mean = mean(red);
green_mean = mean([green1;green2]);
blue_mean = mean(blue);

% White Baalancing Grey World : gw
wb_gw = zeros(size(nBS));
wb_gw(1:2:end, 1:2:end) = red .* green_mean ./ red_mean;
wb_gw(1:2:end, 2:2:end) = green1;
wb_gw(2:2:end, 1:2:end) = green2;
wb_gw(2:2:end, 2:2:end) = blue .* green_mean ./ blue_mean;

% White Balancing White world : ww
red_max = max(red);
green_max = max(green1: green2);
blue_max = max(blue);

wb_ww = zeros(size(nBS));
wb_ww(1:2:end, 1:2:end) = red .* green_max ./ red_max;
wb_ww(1:2:end, 2:2:end) = green1;
wb_ww(2:2:end, 1:2:end) = green2;
wb_ww(2:2:end, 2:2:end) = blue .* green_max ./ blue_max;

figure; imshow(wb_gw);
figure; imshow(wb_ww);

% Choosing wb_gw
dmsc = wb_gw;

% Demosaic

% Red Mosaic
[Y, X] = meshgrid(1:2:Xsize, 1:2:Ysize);
value = dmsc(1:2:end, 1:2:end);

dmsc_a = zeros(size(dmsc));
dmsc_a(1:2:end, 1:2:end) = value;

[Yin, Xin] = meshgrid(2:2:Xsize, 1:2:Ysize);
dmsc_a(2:2:end, 1:2:end) = interp2(Y, X, value, Yin, Xin);
[Yin, Xin] = meshgrid(1:2:Xsize, 2:2:Ysize);
dmsc_a(1:2:end, 2:2:end) = interp2(Y, X, value, Yin, Xin);
[Yin, Xin] = meshgrid(2:2:Xsize, 2:2:Ysize);
dmsc_a(2:2:end, 2:2:end) = interp2(Y, X, value, Yin, Xin);

r_dmsc = dmsc_a;

% Blue Mosaic
[Y,X] = meshgrid(2:2:Xsize, 2:2:Ysize);
value = dmsc(2:2:end, 2:2:end);

dmsc_a = zeros(size(nBS));
dmsc_a(1:2:end, 1:2:end) = value;

[Yin, Xin] = meshgrid(1:2:Xsize, 1:2:Ysize);
dmsc_a(1:2:end, 1:2:end) = interp2(Y, X, value, Yin, Xin);
[Yin, Xin] = meshgrid(1:2:Xsize, 2:2:Ysize);
dmsc_a(1:2:end, 2:2:end) = interp2(Y, X, value, Yin, Xin);
[Yin, Xin] = meshgrid(2:2:Xsize, 1:2:Ysize);
dmsc_a(2:2:end, 1:2:end) = interp2(Y, X, value, Yin, Xin);

b_dmsc = dmsc_a;

[Y1, X1] = meshgrid(1:2:Xsize, 2:2:Ysize);
value1 = dmsc(1:2:end, 2:2:end);

[Y2, X2] = meshgrid(2:2:Xsize, 1:2:Ysize);
value2 = dmsc(2:2:end, 1:2:end);

dmsc_a = zeros(size(dmsc));
dmsc_a(1:2:end, 2:2:end) = value1;
dmsc_a(2:2:end, 1:2:end) = value2;


[Yin, Xin] = meshgrid(1:2:Xsize, 1:2:Ysize);
dmsc_a(1:2:end, 1:2:end) = (interp2(Y1, X1, value1, Yin, Xin) + interp2(Y2, X2, value2, Yin, Xin)) / 2;

[Yin, Xin] = meshgrid(2:2:Xsize, 2:2:Ysize);
dmsc_a(2:2:end, 2:2:end) = (interp2(Y1, X1, value1, Yin, Xin) + interp2(Y2, X2, value2, Yin, Xin)) / 2;

g_dmsc = dmsc_a;

BS_rgb = cat(3, r_dmsc, g_dmsc, b_dmsc);

% Brightness and Gamma Correction

BS_gray = rgb2gray(BS_rgb);
percentage = 4;
BS_rgbrite = BS_rgb * percentage * max(BS_gray(:));

BS_f = zeros(size(BS_rgbrite));
inds = (BS_rgbrite <= 0.0031308);
BS_f(inds) = 12.92 * BS_rgbrite(inds);
BS_f(~inds) = real(1.055 * BS_rgbrite(~inds) .^ (1 / 2.4) - 0.055);

figure; imshow(BS_f);

imwrite(BS_f, 'BS_f_PNG.png', 'png');
imwrite(BS_f, 'BS_f Compressed_95.jpeg', 'jpeg', 'Quality', 95);

imwrite(BS_f, 'BS_f Compressed_20.jpeg', 'jpeg', 'Quality', 20);

%definitely noticable compression at 20 not too much at 30 but anything
%above is indistinguishable unless you zoom in