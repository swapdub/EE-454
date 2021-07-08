function [img1] = myEdgeFilter(img0, sigma)

    Gauss_filter = fspecial('gaussian', 2 * ceil(3 * sigma) + 1, sigma);
    img_filt = myImageFilter(img0, Gauss_filter);

    SobelX = fspecial('sobel');
    SobelY = transpose(SobelX);
    
    imgx = myImageFilter(img0, SobelX);
    imgy = myImageFilter(img0, SobelY);

    imgm = sqrt(imgx.*imgx + imgy.*imgy);
    angle = atan2(imgy, imgx);

    img1 = myNonMaxSup(imgm, angle);

end