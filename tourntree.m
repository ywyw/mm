function [tree] = tourntree(ds_seeds,ds_slots,season )

% input datasets for seeds and tournament slots
% builds a matrix out of dataset in tree form, 67 rows, 2012-present
% 1->2,3 2->4,5 3->6,7 4->8,9
% output matrix of strengths
maxid=max(ds_seeds.team);
tree = zeros(67,maxid);
for a=1:31
    tree(a,:)=[zeros(1,a*2-1) ones(1,2) zeros(1,maxid-a*2-1)];
end

% normal 1:28, 8->4 first four , 60->56->28+4v4
% this builds all the 32 first matches
seeds=ds_seeds(ds_seeds.season==season,:);
slots=ds_slots(ds_slots.season==season,:);

for i=1:4,
    g=slots(i,:);
    f=slots(slots.weakseed==g.slot,'strongseed');
    t=seeds(seeds.seed==f.strongseed,'team');
    tree(32+i-1,32*2+i-1)=1;
    tree(32+i-1,t.team)=1;
end

tournament=join(slots,seeds,'Leftkey','weakseed','Rightkey','seed','Type','inner','Mergekeys',true);
tournament.Properties.VarNames{end}='weakteam';
tournament=join(tournament,seeds,'Leftkey','strongseed','Rightkey','seed','Type','inner','Mergekeys',true);
tournament.Properties.VarNames{end}='strongteam';

%fill with strongteam id and weakteam id, fill zeros, then index to id = 1
for a=1:32
   tree(a+35,tournament{a,'weakteam'})=1; tree(a+35,tournament{a,'strongteam'})=1; 
end

end

