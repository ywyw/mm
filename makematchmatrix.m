function [mm ds_x s1]=makematchmatrix(ds_seeds,x,c,d,f,type)

s1=loadseason(x);
sx = ds_seeds(ds_seeds.season==x,:);
sortx = sortrows(sx,{'team'});
sxcomb = combnk(sortx.team,2);
% generate all combinations of team1 vs team2, naturally lower ID is first
sxnames = strcat(x,'_',num2str(sxcomb(:,1)),'_',num2str(sxcomb(:,2)));
t1=sxcomb(:,1);
t2=sxcomb(:,2);
ds_x = dataset(sxnames,t1,t2);

allteams = zeros(length(s1.wteam),2);
allteams(:,1) = s1.wteam;
allteams(:,2) = s1.lteam;
% weighting time as logistic growth, where recent games have greater effect
% than past games, with relevance falling off sharply for distant past
timevec = 1:length(s1.wteam);
timeweight = 1./(1+c*exp(-1*d*timevec-f));
MINID=501; % adjust for id offset
% use sparse notation to save memory/cycles, this function
% will sum the time-weighted wins into an adjacency matrix
mm = accumarray(allteams(:,1:2)-MINID+1,timeweight,[],[],0,true); 
if(~strcmp(type,'any'))
    mm=accumarray(allteams(:,1:2)-MINID+1,double(s1.wloc==type),[],[],0,true); % adjust for id offset
end
end