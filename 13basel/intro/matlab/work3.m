mtexdata mylonite

grains = calcGrains(ebsd)

plotx2east

[m,index] = max(grainArea)

%%

grainArea = area(grains);       % compute grain area
[n,bin] = hist(grainArea,900:5e4:1.5e6);
bar(bin,n .* bin)


%%

plot(grains,'property','phase')

%%

grains(oriSpread>5*degree)
%%

oriSpread = zeros(size(grains));

for i = 1:numel(grains)
  
  mori = get(grains(i),'mis2mean');
  
  oriSpread(i) = sqrt(mean(angle(mori).^2));
    
end

%%

plot(grains,'property',oriSpread ./ degree)



%% 



sigma001 = tensor([[0 0 0];[0 0 0];[0 0 1]],'name','stress')


% extract the orientations
ori = get(grains('Quartz'),'orientation');

% transform the stress tensor from specimen to crystal coordinates
sigmaCS = rotate(sigma001,inverse(ori))

m = Miller(0,0,0,1,symmetry('quartz')) % normal vector the the slip or twinning plane
n = Miller(1,1,-2,0,symmetry('quartz')) %Burgers vector (slip) or twin shear direction (twinning)


[tauMax,mActive,nActive,tau,ind] = calcShearStress(sigmaCS,m,n,'symmetrise');


plot(grains('quartz'),'property',tauMax')

savefigure('../pic/tau.pdf')
