function argout = ds2cell(argin)
%DS2CELL Converts a dataset array to a Cell-Array.
%   DS2CELL(DSet) converts the Dataset array DSet to a Cell-Array. Each
%   element in the Dataset Array will be converted to an element of the
%   cell array
%
%   See also DATASET, NOMINAL, ORDINAL.

[nobs nvars] = size(argin);
obsnames = get(argin,'ObsNames');
varnames = get(argin,'VarNames');
argout = cell(nobs+1,nvars+1);
argout(1,2:end) = varnames;
argout(2:end,1) = obsnames;

for i = 1:nvars,
    vec = getfield(argin,varnames{i});
    if(~isnumeric(vec))
        vec =cellstr(char(vec));
    else
        vec = mat2cell(vec,ones(nobs,1),1);
    end
    argout(2:end,i+1) = vec;
end
