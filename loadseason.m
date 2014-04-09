function [ seasonXds ] = loadseason( seasons )

% Load and return any regular season A-S

fid = fopen('regular_season_results.csv');
header_regsea = textscan(fid,'%s %s %s %s %s %s %s %s',1, 'delimiter',',');
data_regsea = textscan(fid,'%s %d %d %d %d %d %s %s','delimiter',',');
fclose(fid);
cell_regsea = cell(size(data_regsea{1},1), length(header_regsea));
for i = 1:length(header_regsea)
    if isnumeric(data_regsea{i})
        cell_regsea(:,i) = num2cell(data_regsea{i});
    else
        cell_regsea(:,i) = data_regsea{i};
    end
end
Struct_regsea = cell2struct(cell_regsea, [header_regsea{:}], 2);
ds_regsea = cell2ds(cell_regsea,header_regsea);

seasonXds = ds_regsea(ds_regsea.season==seasons,:);




end

