function outds = cell2ds( inputcell , ColumnNames)
%CELL2DS Converts a Cell-Array to a Dataset Array.
%   CELL2DS(C) converts the Cell-Array C to a Dataset array. 
%   C is a cell which has MxN Elements. Then the output Dataset Array will
%   also have MxN Elements.
%     
%   If the user does not give in any column names as the input, then the
%   function defines its own Column Names as 'Col1','Col2' etc. 
%   
%   CELL2DS(C,ColumnNames) - If the user Specifies the ColumnNames in that
%   variable then the created Dataset Array will have Columns with names as 
%   specified in ColumnNames.
%   Note that ColumnNames should be a Cell Array of Strings. 
%   See also DATASET, NOMINAL, ORDINAL.

elements = inputcell(1:end,1:end);

if ~exist('ColumnNames','var')
    k=size(inputcell,2);
    variables = cellstr( [repmat('col',k,1) num2str((1:k)')]);
else
    variables = ColumnNames;
end;

if ~isnumeric(elements{1,1})
    outds = dataset({nominal(strvcat(elements(:,1))),cell2mat(variables{1})}); %#ok<*REMFF1>
else
    outds = dataset({cell2mat(elements(:,1)),cell2mat(variables{1})});
end


for i  = 2:size(elements,2)
    if ~isnumeric(elements{1,i})
        outds = [outds dataset({nominal(strvcat(elements(:,i))),cell2mat(variables{i})})];
    else
        outds = [outds dataset({cell2mat(elements(:,i)),cell2mat(variables{i})})]; %#ok<*AGROW>
    end
end