function makepred(x,a,b,c,d,f)
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
x=char(x+64) % number to letter 1->A,2->B...S->19
[mX ds_x s1]=makematchmatrix(ds_seeds,x,c,d,f);

zeroRows = find(all(mX==0,2));
zeroCols = find(all(mX==0,1));
% trim the teams that did not have any wins, to ensure convergence
if length(zeroRows)==length(zeroCols)
    mX = mX(~~sum(mX,2),~~sum(mX,2));
elseif length(zeroRows)>length(zeroCols)
    mX = mX(~~sum(mX,2),~~sum(mX,2));
else
    mX=mX(~~sum(mX,1),~~sum(mX,1));
end

[strengthsX] = bt(mX,a,b);
btm_x = grpstats(s1(:,{'wteam'}),'wteam');
btm_x.strengths = strengthsX;
ds_x.Properties.VarNames
btm_x.Properties.VarNames
ds_x_est = join(ds_x,btm_x, 'Leftkey','t1','Rightkey','wteam');
btm_x.Properties.VarNames{end} = 'strengthshigh';
btm_x.Properties.VarNames{2} = 'count2';
ds_x_est.Properties.VarNames
btm_x.Properties.VarNames
ds_x_est=join(ds_x_est,btm_x, 'Leftkey','t2','Rightkey','wteam');
ds_x_est.Properties.VarNames
ds_x_est.pred=(ds_x_est.strengths)./((ds_x_est.strengths)+(ds_x_est.strengthshigh));
var(abs(ds_x_est.pred-.5))
ds_x_est.Properties.VarNames;
ds_x_est(1:5,:)
ds_x_write = ds_x_est(:,{'sxnames','pred'});
ds_x_write.Properties.VarNames{1}='id';

%export(ds_x_write,'File','testprediction11.csv','Delimiter',',');

end

