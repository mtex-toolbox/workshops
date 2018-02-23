

plotx2east

%% 1

mtexdata aachen
clf
plot(ebsd,'property','phase')
axis off
set(gcf,'units','pixels','position',[100 100 600 215])
set(gcf,'renderer','opengl')
savefigure('ebsd_correction_1a.pdf','-r300');

g = calcGrains(ebsd,'keepNotIndexed')
clf
plot(g,'property','phase')
axis off
set(gcf,'units','pixels','position',[100 100 600 215])
set(gcf,'renderer','opengl')
savefigure('ebsd_correction_1b.pdf','-r300');

%% 2 

mtexdata aachen
ebsd = ebsd( get(ebsd,'mad')<1)
clf
plot(ebsd,'property','phase')
axis off
set(gcf,'units','pixels','position',[100 100 600 215])
set(gcf,'renderer','opengl')
savefigure('ebsd_correction_2b.pdf','-r300');

g = calcGrains(ebsd)

clf
plot(g,'property','phase')
axis off
set(gcf,'units','pixels','position',[100 100 600 215])
set(gcf,'renderer','opengl')
savefigure('ebsd_correction_2c.pdf','-r300');



%% 3

mtexdata aachen

clf
plot(ebsd,'property','phase')
axis off
set(gcf,'units','pixels','position',[100 100 600 215])
set(gcf,'renderer','opengl')
savefigure('ebsd_correction_3a.pdf','-r300');

g = calcGrains(ebsd,'keepnotindexed');

clf
plot(g,'property','phase')
axis off
set(gcf,'units','pixels','position',[100 100 600 215])
set(gcf,'renderer','opengl')
savefigure('ebsd_correction_3b.pdf','-r300');


g = g((grainSize(g)>10 & isNotIndexed(g)) | (g('fe') & grainSize(g)>1) | g('mg'))

clf
plot(g,'property','phase')
axis off
set(gcf,'units','pixels','position',[100 100 600 215])
set(gcf,'renderer','opengl')
savefigure('ebsd_correction_3c.pdf','-r300');

ebsd = get(g,'EBSD')
ebsd = ebsd( get(ebsd,'mad')<1)

g = calcGrains(ebsd,'keepnotindexed')


clf
plot(g,'property','phase')
axis off
set(gcf,'units','pixels','position',[100 100 600 215])
set(gcf,'renderer','opengl')
savefigure('ebsd_correction_3d.pdf','-r300');


%%


mtexdata aachen
g = calcGrains(ebsd,'keepnotindexed')

clf
plot(g)
axis off
set(gcf,'units','pixels','position',[100 100 600 215])
set(gcf,'renderer','opengl')
savefigure('ebsd_correction_3c.pdf','-r300');











