function [rhos, thetas] = myHoughLines(H, nLines)
    
    rhos = zeros(nLines, 1);    
    thetas = zeros(nLines, 1);  
    H_nms = H;                  
    H_padded= padarray(H_nms, [1, 1], 'replicate'); 
    [rows, cols] = size(H_nms);

    %% implement non-maximal suppression
    for i = 2:rows-1    
        for j = 2:cols-1
            if any(find((H_padded(i-1:i+1, j-1:j+1) > H_padded(i,j)))) > 0 
                H_nms(i-1,j-1) = 0;     
            end
        end
    end
    
    %% find peaks in hough accumulator
    for i = 1:nLines
        maxIdx = max(H_nms(:));             
        [rhoMaxIdx, thetaMaxIdx] = find(H_nms==maxIdx);
        rhos(i) = rhoMaxIdx(1);             
        thetas(i) = thetaMaxIdx(1);
        H_nms(rhoMaxIdx(1), thetaMaxIdx(1)) = 0;
    end
    

end