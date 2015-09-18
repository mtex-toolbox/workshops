%%                MTEX Workshop Belo Horizonte, 2015
%                     
%%                 Colorcoding Orientations with MTEX
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

%% Data Import

close all; plotx2east
mtexdata forsterite
csFo = ebsd('Forsterite').CS

%%
% By default MTEX plots a phase map for EBSD data.

plot(ebsd)

%%
% You can access the color of each phase by

ebsd('Diopside').color

%%
% These values are RGB values, e.g. to make the color for diopside even
% more red we can do

ebsd('Diopside').color = [1 0 0];

plot(ebsd)

%%
% By default, not indexed phases are plotted as white. To directly specify 
% a color for some ebsd data use the option |FaceColor|.

hold on
plot(ebsd('notIndexed'),'FaceColor','black')
hold off

%% Visualizing arbitrary properties
% Appart from the phase information we can use any other property to
% colorize the EBSD data. As an example we may plot the band contrast

plot(ebsd,ebsd.bc)

mtexColorMap black2white % this makes the image grayscale

%colorbar


%% Defining Colormaps


% this defines a color mapping for the Forsterite phase
oM = ipdfHSVOrientationMapping(ebsd('Forsterite').CS)
%oM = ipdfHSVOrientationMapping(ebsd('Forsterite').CS.properGroup)

% this is the colored fundamental sector
plot(oM)

%% 

% compute the colors
color = oM.orientation2color(ebsd('Fo').orientations);

% plot the colors
close all
plot(ebsd('Forsterite'),color)

%%
% Orientation mappings usually provide several options to alter the
% alignment of colors. 

% figure(1),plot(ipdfHSVOrientationMapping(crystalSymmetry('1')),'upper')
% figure(2),plot(ipdfHSVOrientationMapping(crystalSymmetry('1')),'lower')

% we may interchange green and blue by setting
oM.colorPostRotation = oM.blue2green;

plot(oM)

%%
% or cycle of colors red, green, blue by
oM.colorPostRotation = rotation('axis',zvector,'angle',120*degree);

plot(oM)

%%
% Furthermore, we can explicitly set the inverse pole figure directions by

oM.inversePoleFigureDirection = zvector;

% compute the colors again
color = oM.orientation2color(ebsd('Forsterite').orientations);

% and plot them
close all
plot(ebsd('Forsterite'),color)



%% Coloring certain fibres
% To color a fibre, one has to specify the crystal direction *h* together
% with its rgb color and the specimen direction *r*, which should be
% marked.

oM = ipdfCenterOrientationMapping(csFo);
oM.inversePoleFigureDirection = zvector;
oM.center = Miller(1,1,1,csFo);
oM.color = [0 0 1];
oM.psi = deLaValeePoussinKernel('halfwidth',7.5*degree);


plot(oM)
hold on
circle(Miller(1,1,1,csFo),15*degree,'linewidth',2)
plotIPDF(ebsd('fo').orientations,zvector,...
  'markercolor','k','marker','x','points',200)
hold off

%%

plot(ebsd('fo'),oM.orientation2color(ebsd('fo').orientations))


%% extending the colorcoding

% plotIPDF(ebsd('Fo').orientations,vector3d(1,1,1),'contourf')

oM.center = [Miller(0,0,1,csFo),Miller(0,1,1,csFo),Miller(1,1,1,csFo),...
  Miller(11,4,4,csFo), Miller(5,0,2,csFo) , Miller(5,5,2,csFo)]

oM.color = [[1 0 0];[0 1 0];[0 0 1];[1 0 1];[1 1 0];[0 1 1]];

close all;
plot(oM,'complete')

%%

plot(ebsd('fo'),oM.orientation2color(ebsd('fo').orientations))



%% Do the same with orientations

oM = centerOrientationMapping(ebsd('Fo'));
oM.center = mean(ebsd('Forsterite').orientations);
oM.color = [0,0,1];
oM.psi = deLaValeePoussinKernel('halfwidth',20*degree);

plot(oM,'sections',9,'sigma')

%% Color zooming -  How to visualize sharp textures
% 

% small restart
mtexdata forsterite
plotx2east
ebsd = ebsd('indexed');
[grains,ebsd.grainId] = calcGrains(ebsd)

%%
% the boundary of a specific grain

grains(931).boundary

figure(1)
plot(grains(931).boundary)

%%
% lets combine it with the orientation measurements inside

% define the colorcoding such that the meanorientation becomes white
oM = ipdfHSVOrientationMapping(grains(931));
%oM.inversePoleFigureDirection = grains(931).meanOrientation * oM.whiteCenter;
%oM.whiteCenter = inv(grains(931).meanOrientation) * oM.inversePoleFigureDirection
%oM.colorStretching = 5;
figure(2), plot(oM)

% get the ebsd data of grain 931
ebsd_931 = ebsd(grains(931));

% plot the orientation data
figure(1)
hold on
plot(ebsd_931,oM.orientation2color(ebsd_931.orientations))
hold off


%% Grain boundaries

%% Phase boundaries

close all
plot(grains,'faceAlpha',.3)
hold on
plot(grains.boundary('Fo','En'),'linecolor','r','linewidth',1.5)
hold off

%%  Subboundaries

close all
plot(grains.boundary)
hold on
plot(grains.innerBoundary,'linecolor','r','linewidth',2)


%% Misorientation

close all
gB_Fo = grains.boundary('Fo','Fo');
plot(grains,'translucent',.3)
legend off
hold on
plot(gB_Fo,gB_Fo.misorientation.angle./degree,'linewidth',1.5)
hold off
%colorbar

%% Classifing special boundaries

close all

mAngle = gB_Fo.misorientation.angle./ degree;

hist(mAngle)

[~,id] = histc(mAngle,0:30:120);



%%

plot(grains.boundary,'linecolor','k')

hold on
plot(gB_Fo(id==1),'linecolor','b','linewidth',2,'DisplayName','>40^\circ')
plot(gB_Fo(id==2),'linecolor','g','linewidth',2,'DisplayName','20^\circ-40^\circ')
plot(gB_Fo(id==3),'linecolor','r','linewidth',2,'DisplayName','10^\circ-20^\circ')
plot(gB_Fo(id==4),'linecolor','m','linewidth',2,'DisplayName','< 10^\circ')

hold off


