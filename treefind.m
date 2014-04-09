function [ s1 s2 ] = treefind( tree,inds )
% search the binary tree, and output dataset strengths
% currently set to take maximum strengths, can also try geometric mean
s1=zeros(length(inds),1);
s2=zeros(length(inds),1);
maxtree=tree; % construct tree capturing max values

for i=36:67
    all=find(tree(i,:)==1);
    maxtree(i,all(1))=max(double(inds(inds.t1_wteam==all(1),'strengths')));
    maxtree(i,all(2))=max(double(inds(inds.t2_wteam==all(2),'strengthshigh')));
    max(double(inds(inds.t1a_wteam==all(1),'strengths')));
    max(double(inds(inds.t2a_wteam==all(2),'strengthshigh')));
end

for i=32:35
    all=find(tree(i,:)==1); % first col is next row
    maxtree(i,all(1))=max(maxtree(all(1),:));
    maxtree(i,all(2))=max(max(double(inds(inds.t1_wteam==all(2),'strengths'))),max(double(inds(inds.t2_wteam==all(2),'strengthshigh'))));
    
    %maxtree(i,all(1))=geomean(maxtree(all(1),~~maxtree(all(1),:)));
    %maxtree(i,all(2))=max(max(double(inds(inds.t1a_wteam==all(2),'strengths'))),max(double(inds(inds.t2a_wteam==all(2),'strengthshigh'))));
end

for ir=1:31
    i=32-ir;
    all=find(tree(i,:)==1); % first col is next row
    maxtree(i,all(1))=max(maxtree(all(1),:));
    maxtree(i,all(2))=max(maxtree(all(2),:));
    %maxtree(i,all(1))=geomean(maxtree(all(1),~~maxtree(all(1),:)));
    %maxtree(i,all(2))=geomean(maxtree(all(2),~~maxtree(all(2),:)));
end

for i=1:length(inds)
    team1=inds{i,'t1'};
    team2=inds{i,'t2'};
    row1col=team1;
    row2col=team2;
    max1=inds{i,'strengths'};
    max2=inds{i,'strengthshigh'};
    row1=find(tree(:,row1col)==1);
    row2=find(tree(:,row2col)==1);
    while(row1~=row2)
        geomean(maxtree(row1,~~maxtree(row1,:)));
        geomean(maxtree(row2,~~maxtree(row2,:)));
        max1=geomean([max1,geomean(maxtree(row1,~~maxtree(row1,:)))]);
        max2=geomean([max2,geomean(maxtree(row2,~~maxtree(row2,:)))]);
        row1=find(tree(:,row1)==1);
        row2=find(tree(:,row2)==1);
    end
    s1(i)=max1;
    s2(i)=max2;

end

end

