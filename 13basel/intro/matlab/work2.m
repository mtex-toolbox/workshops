%%

mtexdata aachen

plotx2east

grains = calcGrains(ebsd);



spread = zeros(size(grains));

for i = 1:numel(grains)
  
  spread(i) = mean(angle(get(grains(i),'orientation'),...
    get(grains(i),'orientations')));
  
  
end


%%

plot(grains,'property',spread ./ degree)

colorbar

%%

mtexdata dubna

odf = calcODF(pf)

ebsd = calcEBSD(odf,100)

%%

figure(1)
plot(pf(1))
savefigure('pf1.pdf')

figure(2)
plotpdf(odf,get(pf(1),'h'))
savefigure('pdf1.pdf')

figure(3)
plotpdf(ebsd,get(pf(1),'h'),'grid','on')
savefigure('ebsd1.pdf')