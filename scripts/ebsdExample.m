%%                Chemnitz MTEX Workshop, 2016
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

% load an EBSD data file
ebsd = loadEBSD('Forsterite.ctf','convertEuler2SpatialReferenceFrame')

% reduce the data the faster investigation
%ebsd = reduce(ebsd,4)


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

%%

% compute colors from orientations
ori = ebsd('Fo').orientations;
colors = oM.orientation2color(ori);

% plot the colors
figure(2)
plot(ebsd('Fo'),colors)


%% understanding the colormap

% raise the figure where the color key was plotted
figure(1)

% plot the orientations into the color key
hold all
plotIPDF(ori,'points',250,...
  'MarkerSize',5,'MarkerFaceColor','none','MarkerEdgeColor','k')
hold off

%% the inverse pole figure

% plot the orientations colored according to the color key
plotIPDF(ori,colors,[xvector,yvector,zvector],...
  'points',250,'MarkerSize',7,'MarkerEdgeColor','k')

%% the pole density function

% contour plots if the inverse pole figures
% this takes some time
plotIPDF(ori,[xvector,yvector,zvector],'contourf')
mtexColorbar

%% compute grains

grains = calcGrains(ebsd('indexed'),'threshold',5*degree)

figure(2)
hold on
plot(grains.boundary,'linewidth',2)
hold off

%%

hold on
plot(grains.triplePoints('Fo','Fo','Fo'),...
  'Color','r','MarkerSize',7)
hold off

% -------------------- STOP HERE -------------------------------------
%% combine with other plots

figure(2)
plot(ebsd,ebsd.bc)
mtexColorMap black2white

hold on
plot(ebsd('Fo'),colors,'FaceAlpha',0.5)
hold off


%%  extract properties

figure(1)
clf
hist(ebsd.bc)
xlabel('band contrast')
ylabel('frequency')

%% remove data according to properties

figure(2)
hold on
plot(ebsd(ebsd.bc<50),'Facecolor','r')
hold off

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

