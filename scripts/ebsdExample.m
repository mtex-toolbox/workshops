%%                MTEX Workshop Belo Horizonte, 2015
%
%%                 EBSD Analysis with MTEX
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

%% import data


ebsd = loadEBSD('Forsterite.ctf','convertEuler2SpatialReferenceFrame')


ebsd = reduce(ebsd,4)


%% plot phase information

% adjust plotting convention
plotx2east

% phase plot of the data
plot(ebsd)

%% select data by phase

ebsd('Forsterite')

plot(ebsd('Forsterite'))

%% visualize properties

plot(ebsd,ebsd.bc)

mtexColorMap black2white
mtexColorbar

gcm; % this is the current MTEX figure object
CLim(gcm,[0,150])

%% visualize orientations

% define a color coding
oM = ipdfHSVOrientationMapping(ebsd('Forsterite'));

% with respect to the 001 inverse pole figure
oM.inversePoleFigureDirection = zvector

% visualize the color map
plot(oM)
set(gcf,'renderer','zBuffer')


%%

% compute colors from orientations
ori = ebsd('Fo').orientations;
colors = oM.orientation2color(ori);

% plot the colors
figure(2)
plot(ebsd('Fo'),colors)

%% understanding the colormap

figure(1)

hold all
plotIPDF(ori,'points',250,...
  'MarkerSize',5,'MarkerFaceColor','none','MarkerEdgeColor','k')
hold off

%% the inverse

plotIPDF(ori,[xvector,yvector,zvector],...
  'points',250,'MarkerSize',7,'MarkerEdgeColor','k','property',colors)


%% combine with other plots

figure(2)
plot(ebsd,ebsd.bc)
mtexColorMap black2white

hold on
plot(ebsd('Fo'),colors,'FaceAlpha',0.5)
hold off


%%  extract properties

close all
hist(ebsd.bc)

%% remove data according to properties

plot(ebsd(ebsd.bc<50),'Facecolor','r')

%%
ebsd(ebsd.bc<50).phase = 0;

plot(ebsd)

%% define a region of interest

region = [5000 2000 12000 3000];

rectangle('position',region,'edgecolor','r','linewidth',2)

%% restrict to region of interest

ebsd_roi = ebsd(ebsd.inpolygon(region))

plot(ebsd_roi)

%% a more interactive way

poly = selectPolygon;

plot(ebsd(ebsd.inpolygon(poly)))


%% rotate the data set

rot = rotation('axis',zvector,'angle',20*degree);

plot(rotate(ebsd_roi,rot))


%%

plot(ebsd,ebsd.KAM('threshold',5*degree))
CLim(gcm,[0,0.1])

%%

plot(reduce(ebsd,4))

