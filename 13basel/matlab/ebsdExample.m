%%  Workshop: TEXTURE ANALYSIS AND ORIENTATION IMAGING
%                     Basel, 2013
%
%%             EBSD Analysis with MTEX
%                Ralf Hielscher, TU Chemnitz
%
%%
% The following script demostrates some of the facilities of MTEX to
% import, correct and analyze EBSD data.
%
% Run this script section by section and follow the output. You are
% encauraged to alter the script to get a better feeling about MTEX.
%
% important shortcuts:
% Strg + Return         - run the current section
% Shift + Strg + Return - run the current section and go to the next one
% F9                    - evaluate the selected command
%

%%

% adjust plotting convention
plotx2east

%% import data

ebsd = loadEBSD('example1.ctf','convertEuler2SpatialReferenceFrame')

% ebsd_bad = loadEBSD('example1.ctf')
% ebsd2 = loadEBSD('example1.ctf','convertSpatial2EulerReferenceFrame');


%% plot orientation information

plot(ebsd)


%% plot phase information

plot(ebsd,'property','phase')

%% select data by phase

ebsd('Forsterite')

plot(ebsd('Forsterite'))

%% understanding the colormap

colorbar

hold all
plotipdf(ebsd('Forsterite'),xvector,'points',250,...
  'MarkerSize',5,'MarkerFaceColor','none','MarkerEdgeColor','k')
hold off

%% visualize properties

plot(ebsd,'property','bc')
set(gca,'cLim',[0,150])
mtexColorMap black2white
colorbar

%% combine with other plots

hold on
%plot(ebsd,'colorcoding','ipdfangle','r',zvector,'translucent',0.25)
%set(gca,'cLim',[0,90])
%mtexColorMap blue2red
plot(ebsd,'translucent',0.5)
hold off


%%  extract properties

bc = get(ebsd,'bc');

hist(bc)

%% remove data according to properties

ebsd(bc<50) = 'notIndexed'

plot(ebsd)

%% define a region of interest

region = [5000 2000 12000 3000];

rectangle('position',region,'edgecolor','r','linewidth',2)

%% restrict to region of interest

ebsd_roi = ebsd(inpolygon(ebsd,region))

plot(ebsd_roi)

%%

rot = rotation('axis',zvector,'angle',2*degree);

plot(rotate(ebsd_roi,rot))

%% reconstruct grains

grains = calcGrains(ebsd_roi)

plot(grains)

%% grain properties

hist(grainSize(grains))

%% find the largest grain

grainArea = area(grains);      % compute grain area

[m,index] = max(grainArea)     % find largest grain

plot(grains(index))            % plot largest grain

%% colorize the grain

plotBoundary(grains(index));
hold on
%plot(grains(index),'property','mis2mean','colorcoding','angle')
%colormap gray
plot(grains(index),'property','orientations','sharp')
colorbar
hold off

%%

plot(grains,'property',shapefactor(grains))

%% colorize boundaries according to misorientation angle

plotBoundary(grains,'property','angle','linewidth',2)
colorbar

%% define a specific misorientation

cs = get(ebsd('Fo'),'CS');
h1 = Miller(0,1,1,cs);
mori1 = orientation('axis',h1,'angle',180*degree,cs,cs)
h2 = Miller(1,0,1,cs);
mori2 = orientation('axis',h2,'angle',180*degree,cs,cs)
h3 = Miller(1,1,0,cs);
mori3 = orientation('axis',h3,'angle',180*degree,cs,cs)

%% colorize boundaries according to misorientation

plotBoundary(grains);

hold on

plotBoundary(grains('Fo'),'property',mori1,'delta',5*degree,'linewidth',2,'linecolor','r')
plotBoundary(grains('Fo'),'property',mori2,'delta',5*degree,'linewidth',2,'linecolor','g')
plotBoundary(grains('Fo'),'property',mori3,'delta',5*degree,'linewidth',2,'linecolor','b')

hold off

