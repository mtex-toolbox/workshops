%%             MTEX Workshop Belo Horizonte 2015
%
%%                      Exercises
%
%                Ralf Hielscher (1) and David Mainprice (2)
%
%  (1) TU Chemnitz, Germany
%  (2) Universite Montpellier, France
%
% The following script guides you through the analysis of an Forsterite
% sample. The original script by David Mainprice was about 800 lines. I
% removed all the code and encourage you to rewrite it. You may find some
% hints on the way.
%
% important shortcuts:
% Strg + Return         - run the current section
% Shift + Strg + Return - run the current section and go to the next one
% F9                    - evaluate the selected command
%


%% Import the Data
% This is already complete ...

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('mmm', [4.756 10.207 5.98], 'mineral', 'Forsterite', 'color', 'light blue'),...
  crystalSymmetry('mmm', [18.2406 8.8302 5.1852], 'mineral', 'Enstatite', 'color', 'light green'),...
  crystalSymmetry('12/m1', [9.746 8.99 5.251], [90,105.63,90]*degree, 'X||a*', 'Y||b', 'Z||c', 'mineral', 'Diopside', 'color', 'light red')};

% create an EBSD variable containing the data
ebsd = loadEBSD('pm-17_1.crc',CS,'convertSpatial2EulerReferenceFrame')

% defines axis alignment
plotx2east

%% Exercise 1 - phase map
%
% Visualize the phase map and compute area fractions of the different
% phases
% a) including not indexed pixels
% b) ignoring not indexed pixels
%
% useful commands: ebsd('indexed'), ebsd('notIndexed'), length


%% Exercise 2 - Forsterite texture
%
% Determine the texure index J (Bunge, 1982) and the Uncorrelated
% Misorientation Angle = M-index (Skemer et al., 2005) of the Forsterite
% phase. Do you expect a sharp texture?
%
% useful commands: calcODF, ebsd('phaseName').orientations, textureindex, calcMIndex

odf_Forsterite = calcODF(ebsd('Forsterite').orientations,'halfwidth',10*degree)

J_index_Forsterite = textureindex(odf_Forsterite)

M_index_Forsterite = calcMIndex(odf_Forsterite)

%% Exercise 3 - pole figures
%
% Visualize the <100>, <010> and <001> pole figures of the Forsterite phase
%
% useful commands: plotPDF, mtexColorbar

h = Miller({1,0,0}, {0,1,0}, {0,0,1}, ebsd('Forsterite').CS,'uvw');
plotPDF(odf_Forsterite,h,'colorrange','equal');
mtexColorbar

%% Exercise 4 - band contrast
%
% plot a gray valued image of the band contrast (bc) of the ebsd data
%
% useful commands: reduce, mtexColorMap

ebsd = reduce(ebsd,2)

plot(ebsd,ebsd.bc)
mtexColorMap gray
mtexColorbar

%% Exercise 5 - orientation gradient
%
% Visualize the orientation gradient within the Forsterite phase 
%
% a) plot the misorientation angle to the reference orientation
% (104,90,175)
%
% b) plot the misorientation angle to the mean orientation
% (104,90,175)
%
% c) use an ipf key with inverse pole figure direction such that the mean
% orientation is colored white
%
% useful commands: angle, caxis, ipdfHSVOrientationMapping, 

figure(1)
reference_o = orientation('Euler',104*degree,90*degree,175*degree,ebsd('Forsterite').CS)
ori = ebsd('Forsterite').orientations;
plot(ebsd('Forsterite'), angle(ori,reference_o)./degree)
% set scaling to the angles range 0 - 3 degree
caxis([0 3]);
mtexColorbar

figure(2)
plot(ebsd('Forsterite'),angle(ori,mean(ori))./degree)
mtexColorbar
caxis([0 3])


figure(3)
oM = ipdfHSVOrientationMapping(ebsd('Forsterite').CS);
oM.inversePoleFigureDirection = mean(ebsd('Forsterite').orientations) * oM.whiteCenter;
oM.maxAngle = 3.5*degree;

plot(ebsd('Forsterite'),oM.orientation2color(ebsd('Forsterite').orientations))

%% Exercise 6 - Grain modelling 
% 
% Model grains and plot them on top of the band contrast map. Repeat this
% for different threshold angles 2 .. 15 degree. Analyse the grain size
% distributions. How many grains do only contain one pixel?
%
% useful commands: calcGrains, grains.boundary, grains.grainSize

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',15*degree)

plot(ebsd,ebsd.bc)
hold on
plot(grains.boundary)
hold off

% percentage of one pixel grains
nnz(grains.grainSize == 2) / length(grains) * 100

%% Exercise 7 - removing small grains
%
% a) remove the EBSD data that belong to the one pixel grains or set those
% to notIndexed
%
% b) recompute grains, graidIds and mis2mean
%
% c) plot a phase map and overlay it with the grain boundaries
%
% useful commands: ebsd(grains)

ebsd = ebsd(grains(grains.grainSize > 1));

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd)

%%

plot(ebsd)
hold on
plot(grains.boundary,'linewidth',2)
hold off


%% Exercise 8 - kernel average misorientation (KAM)
%
% Plot the kernel average misorientation and overlay it with the grain
% boundaries
%
% Note KAM is defined using EBSD data, it is the kernel average
% misorientation for each EBSD measurement
% options : 'threshold',10*degree and 'secondOrder'
% Kernels for square EBSD grids
% X = center point *= points used for Kernel
% 1st order KAM (default)    2nd order KAM (option 'secondOrder')
%                                      *
%           *                         ***
%          *X*                       **X**
%           *                         ***
%                                      *
%
% useful commands: ebsd.KAM('threshold',xx*degree)

% compute and visualize the KAM
kam = ebsd('Forsterite').KAM('threshold',3*degree)./degree;
plot(ebsd('Forsterite'),kam)
mtexColorbar
% caxis - allows you focus the scale of the angle range of interest
% example 0 to 3 degrees
caxis([0 1])

% plot grain boundary outline
hold on
plot(grains('Forsterite').boundary,'linewidth',2,'color','w','figSize','large')
hold off


%% Exercise 9
%
% Find the largest grain and 
% a) plot it
% b) mark its center of gravity
% c) determine its phase, area, equivalent diameter
% b) grain equivalent diameter
% c) grain orientation spread (GOS) in degrees
%
% useful commands: grains.area, centroid(grains), grains.GOS,
% grains.aspectRatio, grains.mis2mean

[~,id] = max(grains.area)

lGrain = grains(id)

% grain centroid
[centroid_x,centroid_y] = centroid(lGrain)

% grain axial ratio
lGrain.aspectRatio

% grain area
lGrain.area

% grain equivalent diameter
2 * lGrain.equivalentRadius

% grain equivalent perimeter
lGrain.equivalentPerimeter

% grain orientation spread (GOS) in degrees
lGrain.GOS / degree

% plot ebsd orientation pixels
plot(ebsd(lGrain),ebsd(lGrain).mis2mean.angle./degree)
mtexColorbar
% caxis - allows you focus the scale of the angle range of interest
% example 0 to 5 degrees
caxis([0 3])

hold on
% plot grain boundary outline
plot(lGrain.boundary,'linewidth',2)

% plot grain centroid
plot(centroid_x,centroid_y,'o','MarkerEdgeColor',...
  'k','MarkerFaceColor','r','MarkerSize',10)
hold off


%% Exercise 10 - misorientation line profile
% select a line through the Forsterite grain and plot a misorientation
% profile
%
% a) with respect to the first orienation 
% b) with respect to the neighbouring orientation
%
% useful commands:  ginput, spatialProfile


close all

% plot grain boundary outline with mis2mean
figure(1)
plot(ebsd('fo'),angle(ori,mean(ori))./degree)
caxis([0 3])
mtexColorbar
hold on
plot(grains.boundary,'linewidth',2)
hold off

% Displays a cursor over the map and waits for 2 mouse clicks for the start
% and for the end of the line, respectively
[X_line, Y_line] = ginput(2);
profile_line = [X_line(1) Y_line(1); X_line(2) Y_line(2)];

hold on
% draw profile line
line(profile_line(:,1),profile_line(:,2),'linewidth',4,'color',[0 0 0 0.5])
hold off

% extract orientations and distance along profile_line
[ebsd_line, distance]= spatialProfile(ebsd('Fo'),profile_line);
ori_line = ebsd_line.orientations;

% Misorientation with respect the first point along profile
m_lineSec1 = angle(ori_line(1),ori_line)/degree;

% Misorientation with respect the neighbouring point along profile
m_lineSec2 = angle(ori_line(1:end-1),ori_line(2:end))/degree;

% plot Misorientation angle profile
figure(2)
plot(distance,m_lineSec1,'color','b','linewidth',2)
hold on
plot(0.5*(distance(1:end-1)+distance(2:end)),m_lineSec2,'color','r','linewidth',2)
xlabel('Position (microns)')
ylabel('Misorientation angle in degrees')
title('Misorientation angle profile')
legend('wrt to 1st orientation','orientation gradient','Location','NorthWest')


%% Exercise 11
%
% Plot the axes of the misorientations along the profile line. Colorize the
% axes according
%
% a) the position on the profile line
% b) the rotational angle
% c) make a contour plot of the misorientation axes weighted by the
% misorientation angle
%
% useful commands:  axis, angle, contourf

mAxis = axis(ori_line(1:end-1),ori_line(2:end));
mAngle = angle(ori_line(1:end-1),ori_line(2:end));

plot(mAxis,mAngle,'contourf')

