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


%% Exercise 3 - pole figures
%
% Visualize the <100>, <010> and <001> pole figures of the Forsterite phase
%
% useful commands: plotPDF, mtexColorbar


%% Exercise 4 - band contrast
%
% plot a gray valued image of the band contrast (bc) of the ebsd data
%
% useful commands: reduce, mtexColorMap


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
%
%%
% a)

figure(1)

%%
% b)

figure(2)

%%
% c)

figure(3)


%% Exercise 6 - Grain modelling 
% 
% Model grains and plot them on top of the band contrast map. Repeat this
% for different threshold angles 2 .. 15 degree. Analyse the grain size
% distributions. How many grains do only contain one pixel?
%
% useful commands: calcGrains, grains.boundary, grains.grainSize, nnz


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



%% Exercise 10 - misorientation line profile
% select a line through the Forsterite grain and plot a misorientation
% profile
%
% a) with respect to the first orienation 
% b) with respect to the neighbouring orientation
%
% useful commands: ginput, spatialProfile

% plot grain boundary outline with mis2mean
close all
ori = ebsd('fo').orientations; 
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
