%%                Chemnitz MTEX Workshop 2018
%                     
%%                  EBSD Analysis with MTEX
%            Ralf Hielscher, TU Chemnitz, Germany
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

% import some ebsd data
% here from a 19 Kg meteroit found in Emsland (Germany)
% data from Gert Nolze
ebsd = loadEBSD('Emsland_plessite_500x_15_DS.ctf')


%% displaying the phase

% some conventions
plotx2east
plotzOutOfPlane

% plot the present phases
figure(1)
plot(ebsd)

%% ectracting properties from EBSD data


% syntax: ebds.propertyName
plot(ebsd,ebsd.bc)
mtexColorbar

% adjust the colors to a specific region
%caxis([100 180])

%% Which other properties exists?

ebsd.prop

%struct(ebsd)


%% extracting orientations


ori = ebsd.orientations


%% display the orientations in pole figures
%

% extract orientations
% important: orientations can be extracted only for one phase
ori = ebsd('fe').orientations

% the involved symmetries
cs_bcc = ebsd('Fe').CS

% which crystal planes
h = Miller({1,0,0},{1,1,0},cs_bcc);

figure(2) % plot in a new window
plotPDF(ori,h)

%% rotate EBSD data
% it is important to unerstand the difference between
% 1 - rotating view
% 2 - rotating the spatial coordinates
% 3 - rotating the Euler angles

ebsd_rotated = rotate(ebsd,10*degree,'keepXY')

figure(1)
plot(ebsd_rotated,'micronbar','off','figSize','huge')
figure(2) % plot in a new window
plotPDF(ebsd_rotated('fe').orientations,h)


%% colorize EBSD data according to its orientation
% important: only one phase can be colorized in one command

plot(ebsd('Fe'),ebsd('Fe').orientations,'figSize','large')

% what is going on here?

%% explicite orientation coloring

% define an explicite map for converting orientations into colors
oM = ipdfHSVOrientationMapping(cs_bcc)

% understand the difference to
%oM = ipdfHSVOrientationMapping(cs_bcc.properGroup)

% this map has many parameters which can be set
oM.inversePoleFigureDirection = vector3d.Z;

figure(2)
plot(oM)

%%

% transform orientations into a list of colors
color = oM.orientation2color(ebsd('Fe').orientations);

% plot the ebsd data set
figure(1)
plot(ebsd('Fe'),color,'figSize','huge')

%% plot the orientations into the color key

figure(2)
hold on
plot(ori,'MarkerFaceColor','none','MarkerEdgeColor','black')
hold off

%% implicitely plot a contoured inverse pole figure

figure(3)
plotIPDF(ori, vector3d(0,0,1), 'contourf')
mtexColorbar

%% explicitely plot a contoured inverse pole figure

% the choice of the halfwidth is very important and has
% a big impact on the resulting ODF
odf = calcODF(ori,'halfwidth',2.5*degree)

%%
% there is a method for automatic halfwidth detection
psi = calcKernel(ori)

% you can plug in the kernel directly into 
odf = calcODF(ori,'kernel',psi)

%%

figure(4)
plotIPDF(odf, vector3d(0,0,1),'contourf')
mtexColorbar

%% some chemical information

% import chemical information from a txt file
% here from REM data
ni = txt2mat('ARGUS_Ni.txt');

% look at the size
size(ni)

% look at the size of the ebsd variable
size(ebsd)

% plot them along with the data
plot(ebsd,ni)
mtexColorbar

%%

%look at the pure data
imagesc(ni)


%% add the additional information to the ebsd variable

% turn the data set into rectangular shape
ebsd = ebsd.gridify;

% include the chemical information into the ebsd variable
ebsd.prop.ni = ni;
% flipud(ni) - flip upside down
% fliplr(ni) - flip left right
% transpose(ni) - flip x and y

% plot the chemical information
plot(ebsd,ebsd.ni)

%% compute grains

[grains,ebsd.grainId] = calcGrains(ebsd('indexed'))

grains = smooth(grains,5)

%% overlay chemical information with grain structure

plot(ebsd,ebsd.ni,'figSize','huge')
hold on
plot(grains.boundary,'lineWidth',2)
hold off

%% plot ni concentration into pole figures

h = Miller({1,0,0},{1,0,1},cs_bcc);

ori = ebsd('fe').orientations;

plotPDF(ori, ebsd('fe').ni,h,'points',500)
mtexColorbar
setColorRange([0 20])


%% check for correlations between Ni value and band contrast

clf
scatter(log(ebsd.ni(:)), ebsd.bc(:))
