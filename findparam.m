function [ Lavg ] = findparam( x )
a=x(1);
b=x(2);
c=x(3);
d=x(4);
f=x(5);

%compute mean values
seasonpreds = zeros(1,18);
for i=1:18
   seasonpreds(i)=predictseason(i,a,b,c,d,f)
end

Lavg=mean(seasonpreds);


end

