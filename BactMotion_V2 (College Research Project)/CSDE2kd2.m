function [err] = CSDE2kd2(data,model)
%This second attempt at CSDE() incorporates a Kd-tree Searcher model, which
%allows for potentially much faster indexing through the ~2600 long array
%of model points
%%%
%Closest Squared Distance Error
%This error function's goal is to replace IMMSE() in my ellipsoid fitting
%function. CSDE() will go through each data point, find the closest model
%point, and store the square of that distance. It will then repeat this
%process for every model point, and return the sum of those squared
%distances as the error. This addresses both the issue of different sized
%arrays (which makes using IMMSE() such a hassle) as well as addresses the
%issue of model points that are far away from the data points being
%factored into the error process.

KdTree = KDTreeSearcher(model);
indx = knnsearch(KdTree,data);

dist = (data(:,1)-model(indx,1)).^2 + (data(:,2)-model(indx,2)).^2 ...
     + (data(:,3)-model(indx,3)).^2;
err = sum(dist);
return
end
