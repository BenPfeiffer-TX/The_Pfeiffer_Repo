function [err] = CSDE(data,model)
%Closest Squared Distance Error
%This error function's goal is to replace IMMSE() in my ellipsoid fitting
%function. CSDE() will go through each data point, find the closest model
%point, and store the square of that distance. It will then repeat this
%process for every model point, and return the sum of those squared
%distances as the error. This addresses both the issue of different sized
%arrays (which makes using IMMSE() such a hassle) as well as addresses the
%issue of model points that are far away from the data points being
%factored into the error process.
if ~isa(data,class(model))
    error(message('images:validate:differentClassMatrices','A','B'));
end
if isinteger(data)
    data = double(data);
    model = double(model);
end

err=0;
for d = 1 : length(data)
    dist = 15;
    for m = 1 : length(model)
        temp = ((data(d,1)-model(m,1))^2 + ...
               (data(d,2)-model(m,2))^2 + (data(d,3)-model(m,3))^2);
        if temp < dist
            dist = abs(temp);
        end
    end
    err=err+dist;
end
return
end

