%function to test input vs output with minimum volume ellipsoid

function [outputA,outputC] = errMVE(model)
    initialorient = [0 0 0 0 0 25];
    %make sure to move model up before testing!!!
    %%%%%%%%%%%%%%%%%%%
    outputA = cell(5,1);
    outputC = cell(5,1);
    for i = 1:5
        [outputA{i},outputC{i}] = minVolEllipse(model',0.001);
        %jfc dude this doesnt care about input angle, just do multiple
        %trials
    end
end