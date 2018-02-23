mtexdata aachen

%%

plot(ebsd,'region',[0 90 35 180])

set(gca,'XTick',[],'YTick',[]);
xlabel([]); ylabel([]);
 
savefigure('rawipdf.png')
 
%%

plot(ebsd,'region',[0 90 35 180],'colorcoding','hkl')

set(gca,'XTick',[],'YTick',[]);
xlabel([]); ylabel([]);
 
savefigure('rawhkl.png')

%%

ebsd_rot = rotate(ebsd,3*degree);
plot(ebsd_rot,'region',[-20 90 35 180])

set(gca,'XTick',[],'YTick',[]);
xlabel([]); ylabel([]);
 
savefigure('rawrot.png')

%%
mtexdata aachen
mad = get(ebsd,'mad');
hist(mad)
ebsd = delete(ebsd,mad>0.75)
close all
plot(ebsd,'region',[0 90 35 180])
set(gca,'XTick',[],'YTick',[]);
xlabel([]); ylabel([]);
savefigure('rawmad.png')

%%

mtexdata aachen
[grains,ebsd] = calcGrains(ebsd)
gs = grainsize(grains)
ebsd = link(ebsd,grains(gs > 10))

plot(ebsd,'region',[0 90 35 180])
set(gca,'XTick',[],'YTick',[]);
xlabel([]); ylabel([]);
savefigure('rawSmallGrains.png')

%%

grains = smooth(grains,2,'S')
plot(grains,'region',[0 90 35 180])
set(gca,'XTick',[],'YTick',[]);
xlabel([]); ylabel([]);
xlim([0 35])
savefigure('smoothedGrains.png')
