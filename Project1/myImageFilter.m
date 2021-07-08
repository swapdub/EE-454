function [img1] = myImageFilter(img0, h)
    [j, k] = size(img0);
    [p, q] = size(h);

    padsize = ([p, q] - 1) /2;
    padded_img = padarray(img0,padsize);

    img1 = zeros(j, k);

    for column = 1:j
        for row = 1:k
            img1(column,row) = sum(sum(padded_img(column:column+p-1, row:row+q-1).*h));
        end
    end

end