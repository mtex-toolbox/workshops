%% generate an ODF

set_mtex_option('FFTAccuracy',1e-100);

cs = symmetry('-1');
ss = symmetry('-1');

%odf = unimodalODF(axis2quat(yvector,30*degree),cs,ss,'halfwidth',10*degree) + ...
%  10*fibreODF(Miller(0,0,1),xvector,cs,ss,'halfwidth',10*degree);

odf = 0.2 * uniformODF(cs,ss) ...
  + 0.1 * unimodalODF(axis2quat(yvector,30*degree),cs,ss,'halfwidth',5*degree) + ...
   0.7 * unimodalODF(axis2quat(zvector,80*degree),cs,ss,'halfwidth',10*degree);

%odf = unimodalODF(idquaternion,cs,ss,'halfwidth',10*degree);
    
 %plot(odf)


%% compute ODF characteristia
L = 80;
s = 2;
odf = calcFourier(odf,L);
fhat = ChebCoeff(odf);
L = length(fhat)-1;
Lr = 0:L;

%Sobolev weight
w = (0:L).^(s/2) .* (1:L+1).^(s/2);

sn = norm(odf,'weighted',w,'Fourier')
norm(odf,'weighted',ones(1,L+1),'Fourier')
norm(odf,'Fourier')

% precompute discretisation of SO3
%res = 2.5*degree;
%S3G_global = SO3Grid(res,cs,ss);
%odf_S3G = eval(odf,S3G_global); %#ok<EVLC>


%% big loop

maxd = 7.5;

% a large zero error matrix
rep = 50;
e = zeros(2*maxd,7,rep);

for d = 1:2*maxd
%for d = 13:14
  
  N = round(10^(d/2));
  % Simualte EBSD Data

  
  for i = 1:rep
  
    ebsd = simulateEBSD(odf,N);
    
    psi = kernel('Dirichlet',L);
    odf_d = calcODF(ebsd,'kernel',psi,'Fourier','L',L);
  
  
    % practical optimal MISE

    % optimal kernel function
    A = (2*Lr+1) .* N .* fhat.^2 ./ (1 + (N-1).*fhat.^2);
    psi = kernel('Fourier',A);
    eodf = conv(odf_d,psi);
    
    e(d,1,i) = norm(Fourier(eodf,'l2-normalization') - Fourier(odf,'l2-normalization')).^2;

    % Jackson kernel
    %kappa = N^(2/7) * sn^(4/7) * 2^(8-2*s) * exp(3) / 9 / pi;
    
    %kappa = (4/3 - 8/(s+3) + 4/(2*s+3))^(-3/(2*s+3)) * (2*s/3 * sn^2 * N)^(s/(2*s+3));
    kappa = (5/2 * sn^2 * N)^(1/7);
    
    psi = kernel('Jackson',kappa);
    eodf = conv(odf_d,psi);
    e(d,2,i) = norm(Fourier(eodf,'l2-normalization') - Fourier(odf,'l2-normalization')).^2;
    
    % Dirichlet kernel
    kappa = N^(1/7) * sn^(2/7);
    
    psi = kernel('Dirichlet',kappa);
    eodf = conv(odf_d,psi);
    e(d,3,i) = norm(Fourier(eodf,'l2-normalization') - Fourier(odf,'l2-normalization')).^2;
    
    
    % de la Vallee Poussin
    kappa = 2 * (N^2 * sn^4 / 9 / pi)^(1/7);
    
    psi = kernel('de la Vallee Poussin',kappa);
    eodf = conv(odf_d,psi);
    e(d,4,i) = norm(Fourier(eodf,'l2-normalization') - Fourier(odf,'l2-normalization')).^2;
    
    % Abel Poisson
    kappa = 1-(2^(s+2) * 3 / N / sn^2)^(1/5);
    
    psi = kernel('Abel Poisson',kappa);
    eodf = conv(odf_d,psi);
    e(d,5,i) = norm(Fourier(eodf,'l2-normalization') - Fourier(odf,'l2-normalization')).^2;
    
    %
    %A = 2 * Lr ./ (1 + Lr.^s .* (Lr + 1).^s .* (2*Lr + 1).^2 .* kappa^2);
    %psi = kernel('Fourier',A);
    %eodf = conv(odf_d,psi);
    
    %e(d,7,i) = norm(Fourier(eodf,'l2-normalization') - Fourier(odf,'l2-normalization')).^2;
    
    mean(e,3)
        
  end
end


%% The theoretical bounds

d = linspace(0.5,maxd);
N = 10.^d;

et = [];

for i = 1:length(N)
  
  % compute theoretical optimal MISE
  et(i,1) = sum( (2*Lr+1).^2 .* fhat.^2 .* (1-fhat.^2) ./ (1 + (N(i)-1).*fhat.^2) );
  
  
  % optimal dirichlet
  et(i,3) = 7/3 * N(i)^(-4/7) * sn^(6/7);
end

x = [N.',et./norm(odf,'Fourier')^2];
save('exact_3.txt','x','-ascii')

%% save absolut error

x = [10.^((1:2*maxd)/2).',mean(e,3)./norm(odf,'Fourier')^2,std(e,1,3)./norm(odf,'Fourier')^2];
save('error_3.txt','x','-ascii')

x = [10.^((1:2*maxd)/2).',diag(1./mean(e(:,1,:),3)) * mean(e,3) ];
save('relerror_3.txt','x','-ascii')

%% output

loglog(10.^((1:2*maxd)/2),mean(e,3)./rep./norm(odf,'Fourier')^2)
hold on
loglog(N,et./rep./norm(odf,'Fourier')^2)
hold off

%%
loglog(10.^((1:2*maxd)/2),std(e,1,3)./norm(odf,'Fourier')^2)
%%

loglog(10.^((1:2*maxd)/2),std(e,1,3)./rep./norm(odf,'Fourier')^2)

%%



for d = 1:2*maxd
  
  N = round(10^(d/2));
  ebsd = simulateEBSD(odf,N);
  
  eodf = calcODF(ebsd,'halfwidth','auto');
  e(d,3) = norm(Fourier(eodf,'l2-normalization') - Fourier(odf,'l2-normalization')).^2;
        
end


%% simulate EBSD data




%%




%% compute optimal AMISE p = 2
p = 2;
s = 2;
d = (2*s-1)/3;

Ips = 1;

AMISE2 = (d^(1/d+1)  + d^(-d/(d+1))) * Ips^(1/d+1) * normif^(2/(d+1)) * N^(-d/d+1);

%% compute optimal AMISE p = \infty
p = inf;
s = 2.5;
d = 2*s/3;

Ips = (4/3 - 8 / (s+3) + 4/(2*s + 3))^d;
AMISEi = (d^(1/d+1)  + d^(-d/(d+1))) * Ips^(1/d+1) * norm2f^(2/(d+1)) * N^(-d/d+1);

%% de la Vallee Poussin


%psi = kernel('de la Vallee Poussin',20);
e = zeros(1,5);
for iN = 1:5
  
  N = 10^iN;
  e(iN) = MISE(odf,psi,N,min(10,max(1,1000/N)));
  disp(e);
end



%%

cs = symmetry('-1');
ss = symmetry('-1');

odf = fibreODF(Miller(0,0,1),xvector,cs,ss,'halfwidth',10*degree);

ebsd = simulateEBSD(odf,10000);

eodf = calcODF(ebsd);

calcError(odf,eodf)

%% 

