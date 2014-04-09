function [ LX ] = predictseason ( x,a,b,c,d,f)
% x is string with season name A-Z
x=char(x+64) % number to letter 1->A,2->B...R=18,S=19

% suggested parameters: 1.02,0.006,1,.001,0
a=1.02; b=0.006; c=1; d=0.001; f=0;

fid = fopen('tourney_seeds.csv');
header_seeds = textscan(fid,'%s %s %s',1, 'delimiter',',');
data_seeds = textscan(fid,'%s %s %d','delimiter',',');
fclose(fid);
cell_seeds = cell(size(data_seeds{1},1), length(header_seeds));
for i = 1:length(header_seeds)
    if isnumeric(data_seeds{i})
        cell_seeds(:,i) = num2cell(data_seeds{i});
    else
        cell_seeds(:,i) = data_seeds{i};
    end
end
Struct_seeds = cell2struct(cell_seeds, [header_seeds{:}], 2);
ds_seeds = cell2ds(cell_seeds,header_seeds);

fid = fopen('tourney_results.csv');
header_result = textscan(fid,'%s %s %s %s %s %s %s',1, 'delimiter',',');
data_result = textscan(fid,'%s %d %d %d %d %d %s','delimiter',',');
fclose(fid);
cell_result = cell(size(data_result{1},1), length(header_result));
for i = 1:length(header_result)
    if isnumeric(data_result{i})
        cell_result(:,i) = num2cell(data_result{i});
    else
        cell_result(:,i) = data_result{i};
    end
end
Struct_result = cell2struct(cell_result, [header_result{:}], 2);
ds_result = cell2ds(cell_result,header_result);
ds_resultX = ds_result(ds_result.season==x,:);
% add lower,upper, sort the results by lower,upper then concat
ds_resultX.lownum = min(ds_resultX.wteam,ds_resultX.lteam);
ds_resultX.highnum = max(ds_resultX.wteam,ds_resultX.lteam);
ds_resultX = sortrows(ds_resultX,{'lownum','highnum'});
ds_resultX.fullname = strcat(char(ds_resultX.season),'_',num2str(ds_resultX.lownum),'_',num2str(ds_resultX.highnum));
ds_resultX.y = double((ds_resultX.lownum==ds_resultX.wteam));

[mX ds_x s1 ]=makematchmatrix(ds_seeds,x,c,d,f,'any');
zeroRows = find(all(mX==0,2));
zeroCols = find(all(mX==0,1));
size(zeroRows);
size(zeroCols);

if length(zeroRows)==length(zeroCols)
    mX = mX(~~sum(mX,2),~~sum(mX,2));
elseif length(zeroRows)>length(zeroCols)
    mX = mX(~~sum(mX,2),~~sum(mX,2));
else
    mX=mX(~~sum(mX,1),~~sum(mX,1));
end

%[mX ds_x s1 ]=makematchmatrix(ds_seeds,x,c,d,f,'any');
% [mn ds_x s1] = makematchmatrix(ds_seeds,x,c,d,f,'N');
% [ma ds_x s1] = makematchmatrix(ds_seeds,x,c,d,f,'A');
% [mh ds_x s1] = makematchmatrix(ds_seeds,x,c,d,f,'H');
% ma=ma(~~sum(mX,2),~~sum(mX,2));
% mn=mn(~~sum(mX,2),~~sum(mX,2));
% mh=mh(~~sum(mX,2),~~sum(mX,2));
%[strengthsX]=btt(mn,mh,ma,a,b); %option to use home/away/neutral split

[strengthsX] = bt(mX,a,b);
bt_x = grpstats(s1(:,{'wteam'}),'wteam');
bt_x.strengths = strengthsX;
ds_x_est = join(ds_x,bt_x, 'Leftkey','t1','Rightkey','wteam');
bt_x.Properties.VarNames{end} = 'strengthshigh';
bt_x.Properties.VarNames{2} = 'count2';
ds_x_est=join(ds_x_est,bt_x, 'Leftkey','t2','Rightkey','wteam');
test = ds_x_est.strengths./(ds_x_est.strengths+ds_x_est.strengthshigh);
ds_resultXjoin = join(ds_resultX,ds_x_est,'Leftkey','fullname','Rightkey','sxnames');
ds_resultXjoin;
ds_resultXjoin.pred = (ds_resultXjoin.strengths)./((ds_resultXjoin.strengths)+(ds_resultXjoin.strengthshigh));
var(abs(ds_resultXjoin.pred-.5));

n=length(ds_resultXjoin.pred)
LX = -1/n*sum(ds_resultXjoin.y.*log(ds_resultXjoin.pred)+(ones(n,1)-ds_resultXjoin.y).*log(ones(n,1)-ds_resultXjoin.pred));


end

