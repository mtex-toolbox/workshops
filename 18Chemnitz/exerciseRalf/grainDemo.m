%%                 Chemnitz MTEX Workshop 2018
%                     
%%                  Grains Analysis with MTEX
%                Ralf Hielscher, TU Chemnitz, Germany
%
%%
% The following script demostrates some of the facilities of MTEX to
% analyze grains.
%
% Run this script section by section and follow the output. You are
% encauraged to alter the script to get a better feeling about MTEX.
%
% important shortcuts:
% Strg + Return         - run the current section
% Shift + Strg + Return - run the current section and go to the next one
% F9                    - evaluate the selected command
%

%% Data import

% plotting convention
plotx2east

% import the ebsd data
ebsd = loadEBSD('Emsland_plessite_500x_15_DS.ctf')

% add the chemical information
fe = txt2mat('ARGUS_Fe.txt');
ni = txt2mat('ARGUS_Ni.txt');
ebsd = ebsd.gridify;
ebsd.prop.fe = fliplr(fe);
ebsd.prop.ni = fliplr(ni);

% extract crystal symmetries
cs_bcc = ebsd('Fe').CS;
cs_aus = ebsd('Aus').CS;

%% Grain reconstruction

% consider only the indexed pixels
ebsd = ebsd('indexed');

% reconstruct grains - note the three different return values
% 1. the grains
% 2. the grainId
% 3. the misorientation to the mean orientation
%[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd)
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'angle',3.5*degree)

% reduce the stair casing effect in grain boundaries
grains = smooth(grains,4);

%% Visualize the grain boundaries

plot(ebsd('fe'), ebsd('fe').orientations, 'figSize','huge');

hold on
plot(grains.boundary)
hold off

%% 

% lets throw away all data which belong to very small grains
small_grains = grains(grains.grainSize<=3);
ebsd(small_grains) = [];

% note: this changes the ebsd variable
% we should recompute grains in order to assign the now unindexed pixels to
% the bigger grains

%% find the largest grain

[max_area,id] = max(grains.area)

hold 
plot(grains(id).boundary,'lineWidth',2,'lineColor','r')
%plot(grains(id),'FaceAlpha',0.25,'faceColor',[0 0 0])
hold off

%% plot a single grain

% select the EBSD data that belong to a certain grain
ebsd_grain = ebsd(grains(id));

ebsd_grain = ebsd(ebsd.grainId==id)

ebsd.bc(ebsd.grainId==id);
ebsd(ebsd.grainId==id).bc;
ebsd(grains(id)).bc;
ebsd.bc(grains(id)) % does not work

%%

plot(ebsd_grain, ebsd_grain.orientations,'micronbar','off','figSize','huge')
hold on
plot(grains(id).boundary)
hold off

%% investigate the biggest grain

% define an orientation to color mapping
oM = ipdfHSVOrientationMapping(cs_bcc);
oM.inversePoleFigureDirection = ...
  grains(id).meanOrientation * oM.whiteCenter;
% oM.maxAngle = 5*degree
%oM.colorStretching = 10

% compute the color
color = oM.orientation2color(ebsd_grain.orientations);

% plot the orientations within the grain
plot(ebsd_grain, color,'micronbar','off','figSize','huge')

% plot the grain boundary
hold on
plot(grains(id).boundary)
hold off

%% transfer EBSD properties to grain properties
% 

% assign to each grain the mean of the chemical information
grains.prop.fe = accumarray(ebsd.grainId,ebsd.fe,[],@mean);
grains.prop.ni = accumarray(ebsd.grainId,ebsd.ni,[],@mean);

%grains.prop.bc = accumarray(ebsd.grainId,ebsd.fe,[],@median);

% plot grains with their property
plot(grains,grains.fe,'figSize','huge')


%% investigate grain inclination
%
% maybe there is a connection between the inclination of the grain and its
% crystal orientation

% consider only grains which have a clear inclination
gg = grains(grains.aspectRatio > 5);
gg = gg('fe')

% plot those grains with their meanorientation
plot(gg,gg.meanOrientation)

%%

% compute grain destinction
destinction = mod(gg.principalComponents./degree,180);

% plot 100, 110 and 111 pole figures
h = Miller({1,0,0},{1,1,0},{1,1,1},cs_bcc);
plotPDF(gg.meanOrientation,destinction,h)
caxis([0,180])
mtexColorMap HSV
mtexColorbar

%% 
% the same in 3d

plot(gg.meanOrientation,destinction,'axisAngle')
caxis([0,180])
mtexColorMap HSV

%% Something funny - grains from suplemental data
%

gg = calcGrains(ebsd,'custom',ebsd.fe,'delta',5)

plot(ebsd,ebsd.fe,'micronbar','off')
hold on
plot(gg.boundary)
hold off
