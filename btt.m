function [p th]=btt(nm,hm,am,a,b)

% Bradley Taylor on home/away/neutral games
% nm neutral matrix of games, hm home, am away
% output vector of team strengths

n=size(nm,1);
MINDIFF=1e-6;
p=ones(n-1,1);
theta = 1; % parameter for home advantage, set to no effect to start
diff=1e100;
difft=1e100;
totmat=nm+hm+am;
Wh=am(:,1:n-1)'+hm(1:n-1,:);
Wa=hm(:,1:n-1)'+am(1:n-1,:);
Wn=nm(1:n-1,:);
winshome=sum(sum(hm));
winstot=sum(totmat(1:n-1,:),2);
ind = (Wh+Wa+Wn)>0;
denom=zeros(n-1,n);
denomt=zeros(n-1,n);
psum=denom;
psuma=denom;
psumn=denom;
at=a;
bt=b;

while norm(diff) > MINDIFF || norm(difft) >  MINDIFF % condition for convergence
	ps=p(:,ones(n,1)); % make n column copies of pi (ps)
	pt=ps(:,1:n-1)';
	pt(:,n)=ones(n-1,1); % rows of p (pi) we always consider last weight = 1
	psum(ind)=theta*ps(ind)+pt(ind);
	psuma(ind)=theta*pt(ind)+ps(ind);
    psumn(ind)=ps(ind)+pt(ind);
	denom(ind) = theta*Wh(ind) ./ psum(ind)+Wa(ind)./psuma(ind)+Wn(ind)./psumn(ind);
	ptemp=(winstot+a-1) ./ (sum(denom,2)+b);
	diff=ptemp-p; 
	p=ptemp;
    
    ps=p(:,ones(n,1)); % make n column copies of pi (ps)
	pt=ps(:,1:n-1)';
	pt(:,n)=ones(n-1,1); % rows of p (pi) we always consider last weight = 1
    denomt(ind) = Wh(ind).*ps(ind)./(theta*ps(ind)+pt(ind))+Wn(ind).*ps(ind)./(ps(ind)+pt(ind));
    temptheta = (winshome+(at-1)) / (sum(sum(denomt))+bt);
    difft = temptheta-theta;
end

p(n)=1;
th=theta;