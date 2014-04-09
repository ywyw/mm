function p=bt(W,a,b)
%
% Bradley-Terry model minorization maximization algorithm
%
% input adjacency matrix of game winnings i vs j, output team strength
% estimates

n=size(W,1);
MINDIFF=1e-08;

% constrain the norm of last value to 1 instead of normalizing entire
% vector to 1, this is easier computationally and equivalent
p=ones(n-1,1); % initialize all teams equal strength
diff=1e100; % initialize large starting value
wi=W(:,1:n-1)'+W(1:n-1,:);
wintot=sum(W(1:n-1,:),2);
ind=(wi>0); % we can naturally avoid s=i this way
denom=zeros(n-1,n);

% extra term: +mu*sum(log(pi/(sum(pi)+1)))
while norm(diff) > MINDIFF  % condition for convergence
	ps=p(:,ones(n,1)); % make n column copies of pi (ps)
	pt=ps(:,1:n-1)';
	pt(:,n)=ones(n-1,1); % rows of p (pi) we always consider last weight = 1
	denom(ind) = (a-1+wi(ind)) ./ (b+ps(ind)+pt(ind));
	ptemp=wintot ./ sum(denom,2);
	diff=ptemp-p; % how do we normalize
	p=ptemp;
end

p(n)=1;