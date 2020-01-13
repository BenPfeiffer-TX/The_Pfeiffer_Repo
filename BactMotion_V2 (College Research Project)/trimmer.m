function [newB] = trimmer(newB,trjR,B,tiff_stack,T,trash,expmaxB)
%Takes newB and "trims" out the blank rows, giving back a much more compact
%array that's faster to index through and easier to traverse by eye. 
%This function is a potential computatational time bottleneck since we're
%writing to a new array and then saving that over the original, and with
%very large file sizes this gets to be more costly than it might be worth
%(analysis needed for that claim)
for t = 1 : T
    for tr = 1 : length(trjR(t,1,:))
        for b1 = 1 : length(B{t})
            if trash(b1,t) == 0
                tempb = cell2mat(B{t}(b1));
                if ismember(round(trjR(t,2,tr)), (min(tempb(:,1)):max(tempb(:,1))) ) == true ...
                        && ismember(round(trjR(t,1,tr)), (min(tempb(:,2)):max(tempb(:,2))) ) == true
                    newB(tr,t) = B{t}(b1);
                end
            end
        end
    end
end



% tempnewB = cell(1,length(tiff_stack(1,1,:)));
% id = 1;
% for i = 1 : expmaxB
%     check = 0;
%     for t = 1 : length(tiff_stack(1,1,:))
%         if isempty(newB{i,t}) == false
%             check = check+1;
%         end
%     end
%     if check > 0
%         tempnewB(id,:)=newB(i,:);
%         id=id+1;
%     end
% end



%This loop structure goes through newB and erases the duplicate
%trajectories, since apparently they're getting made even though troika is
%creating separate trajectories
% for t = 1 : T
%     for b = 1 : length(tempnewB(:,1))-2
%         if isequal(tempnewB{b,t},tempnewB{b+1,t}) == true
%             counta=1;
%             countb=1;
%             for tt = 1 : T
%                 if isempty(tempnewB{b,tt})==false
%                     counta=counta+1;
%                 end
%                 if isempty(tempnewB{b+1,tt})==false
%                     countb=countb+1;
%                 end
%             end
%             if counta >= countb
%                 for tt = 1 : T
%                     tempnewB{b+1,tt} = [];
%                 end
%             else
%                 for tt = 1 : T
%                     tempnewB{b,tt} = [];
%                 end
%             end
%         elseif isequal(tempnewB{b,t},tempnewB{b+2,t}) == true
%             counta=1;
%             countb=1;
%             for tt = 1 : T
%                 if isempty(tempnewB{b,tt})==false
%                     counta=counta+1;
%                 end
%                 if isempty(tempnewB{b+2,tt})==false
%                     countb=countb+1;
%                 end
%             end
%             if counta >= countb
%                 for tt = 1 : T
%                     tempnewB{b+2,tt} = [];
%                 end
%             else
%                 for tt = 1 : T
%                     tempnewB{b,tt} = [];
%                 end
%             end
%         end
%     end
% end
end

