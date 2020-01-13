function [trash,heightmap,B] = trashmapper(filename,T,tiff_stack,trjR,trash)
%This function both generates the actual heightmaps, which in turn also
%creates the boundaries of the bacteria in each frame and labels what
%bacteria are considered "trash".
bactcount = zeros(length(tiff_stack(1,1,:)),1);
expmaxB = length(trjR(1,1,:));
lam = 0.3;
B = cell(1,length(tiff_stack(1,1,:)));
heightmap = zeros(size(tiff_stack));
ts = zeros(size(tiff_stack));
% area1=cell(1);
for t = 1 : T
    I = imread(filename,t);
    I = mat2gray(I);
    BW = imbinarize(I,'adaptive','sensitivity',0.1);
    [Bl,L] = bwboundaries(BW,'noholes');
    B{:,t} = Bl(:); % ^ These lines are what generate the boundaries ^
    
%     if t == 147
%         if filename == 'subset1.tif'
%             B{t}=B{t}(1:expmaxB);
%         end
%     end
    
    area  = cell2mat(struct2cell(regionprops(BW,I,'Area')));
%     area1{t} = area;
    minarea = 50;
    maxarea = 500;
    for b1 = 1 : length(B{t})
        if area(b1) < minarea || area(b1) > maxarea
            trash(b1,t) = b1;
        else
            trash(b1,t) = 0;
        end
    end %If a bacteria is too small, we trash it
    bactcount(t) = length(find(trash(:,t)==0));
    ts(:,:,t) = double(tiff_stack(:,:,t));
    for x1 = 1 : length(tiff_stack(:,1,1))
        for y1 = 1 : length(tiff_stack(1,:,1))
            if L(x1,y1) ~= 0 && L(x1,y1) <= expmaxB
                if trash(L(x1,y1),t) == L(x1,y1)
                    L(x1,y1) = 0;
                end
            end
            if L(x1,y1) == false
                ts(x1,y1,t) = NaN;
                %We also mark out the trash bacteria in the logic map as well
                %even though it isn't used for anything
            end
        end
    end
    maxI = max(max(ts(:,:,t)));
    heightmap(:,:,t) = lam*log(maxI./(ts(:,:,t)));
    %This is where we actually generate the heightmap pixel by pixel, with
    %everything scaled to the max intensity of that frame
end
end

