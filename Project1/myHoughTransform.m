function [H, rhoScale, thetaScale] = myHoughTransform(Im, threshold, rhoRes, thetaRes)

[m, n] = size(Im); 
rhoMax = sqrt(m^2 + n^2); 
thetaRes = thetaRes * (180/pi); 

rhoScale = ceil(-rhoMax):rhoRes:ceil(rhoMax); 
thetaScale = -90:thetaRes:90;
rhoLen = numel(rhoScale); 
thetaLen = numel(thetaScale); 
H = zeros(rhoLen, thetaLen); 

[edge_xIdx, edge_yIdx] = find(Im > threshold); 

for i = 1:numel(edge_xIdx)
    for thetaIdx = 1:thetaLen 
       rhoCurrent = edge_yIdx(i)*cosd(thetaScale(thetaIdx)) + edge_xIdx(i)*sind(thetaScale(thetaIdx));
       rhoCurrent = floor(rhoCurrent/rhoRes) * rhoRes; 
       thetaCurrent = floor(thetaScale(thetaIdx)/thetaRes) * thetaRes; 
       thetaBinIdx = find(thetaScale==thetaCurrent); 
       rhoBinIdx = find(rhoScale==rhoCurrent);
       H( rhoBinIdx, thetaBinIdx ) = H( rhoBinIdx, thetaBinIdx ) + 1; 
    end
end

thetaScale = thetaScale .* (pi/180); 
        
end