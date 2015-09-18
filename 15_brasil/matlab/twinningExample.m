%%                MTEX Workshop Belo Horizonte, 2015
%
%%                 Twinning Analysis with MTEX
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

%% data import

% load the data
ebsd = loadEBSD('twinning.ctf','convertEuler2SpatialReferenceFrame')

% consider only the Magnesium phase
ebsd = ebsd('Magnesium');

%%
% set up plotting conventions
%     x
%   ----->
%  |
% y|
%  V
plotzIntoPlane
plotx2east

% define an orientation mapping
% and adapt it to fit the given one
oM = ipdfHSVOrientationMapping(ebsd.CS.properGroup);
oM.inversePoleFigureDirection = yvector

figure(2)
plot(oM)

%% visualize the ebsd data 

figure(1)
plot(ebsd,oM.orientation2color(ebsd.orientations))

%% compute the grains with theshold 5 degree

grains = calcGrains(ebsd,'angle',5*degree)

grains = smooth(grains)

%% extract the grain boundaries and plot them

gB = grains.boundary

hold on
plot(gB,'linewidth',2)
hold off

%% compute the misorientation between two grains

mori = inv(grains(65).meanOrientation) * grains(74).meanOrientation;

%% select twinning boundaries

% define a twinning misorientation
twinMori = orientation('axis',Miller(1,-2,1,0,ebsd.CS,'uvw'),...
  'angle',86.3*degree,ebsd.CS,ebsd.CS)

% consider only Magnesium to Magnesium grain boundaries
gBM2M = gB('Magnesium','Magnesium');

% restrict to twinnings with threshold 5 degree
isTwinning = angle(gBM2M.misorientation,twinMori) < 5*degree;
twinBoundary = gBM2M(isTwinning)

% plot the twinning boundaries
hold on
plot(twinBoundary,'linecolor','w','linewidth',2)
hold off


%% Other properties that might help to identify grain boundaries

% a shortcut: check for twinning
gBM2M.isTwinning(twinMori,5*degree)

% the direction - antipodal!!
gBM2M.direction

% the length of one segment
gBM2M.segLength;

% the number of connected segments
gBM2M(isTwinning).segmentSize;


%% merge twins along twin boundaries

[mergedGrains,parentId] = merge(grains,twinBoundary);

% plot the merged grains
hold on
plot(mergedGrains.boundary,'linecolor','b','linewidth',1,'linestyle','-')
hold off

%% grain relationships

% each merged grain has an id, i.e.,
mergedGrains(20).id

% which refers to the second output argument parentId and  indicates into
% which grain it has been merged, hence, one can find the childs of
% mergedGrains(20) by
childs = grains(parentId == mergedGrains(20).id)

% for each of the childs one can get Euler angles
childs.meanOrientation

% and the grain size
childs.grainSize

% or
childs.area


%% calculate the twinned area
%
% grains has twinned if they have a twinning boundary

twinId = unique(gBM2M(isTwinning).grainId);

% compute the area fraction
sum(area(grains(twinId))) / sum(area(grains)) * 100
