%% Grain Reconstruction
% Grain Reconstruction from EBSD data.

%% 
close all
plotx2east
mtexdata forsterite

poly = [4 2 13 3]*10^3
ebsd = ebsd(ebsd.inpolygon(poly));

plot(ebsd)

set(gcf,'renderer','painters')
%saveFigure('../pic/ebsdPhase.pdf')

%% grain reconstruction

[grains,ebsd.grainId,ebsd.mis2mean] = ...
  calcGrains(ebsd,'angle',7.5*degree)

%%
% start overide mode
hold on

% plot the boundary of all grains
plot(grains.boundary,'linewidth',1.5)

% stop overide mode
hold off

%set(gcf,'renderer','painters')
%saveFigure('../pic/ebsdGrainsRaw.pdf')

%%

ebsd = ebsd(grains)



%% Misorientation to mean orientation

plot(ebsd,ebsd.mis2mean.angle ./ degree), CLim(gcm,[0,5])
%plot(ebsd,ebsd.KAM ./ degree); CLim(gcm,[0,5])

hold on
plot(grains.boundary)
hold off

mtexColorbar

%set(gcf,'renderer','painters')
%saveFigure('../pic/ebsdMis2Mean.pdf')

%%
% We can examine the misorientation to mean for one specific grain as
% follows

% select a grain by coordinates
myGrain = grains(9075,3275)
plot(myGrain.boundary,'linewidth',2)

% plot mis2mean angle for this specific grain
hold on
plot(ebsd(myGrain),ebsd(myGrain).mis2mean.angle ./ degree)
hold off
%colorbar


%% Filling not indexed holes
% compute the grains from the indexed measurements only

grains = calcGrains(ebsd('indexed'))

plot(ebsd)

% start overide mode
hold on

% plot the boundary of all grains
plot(grains.boundary,'linewidth',1.5)

% mark two grains by location
%plot(grains(11300,6100).boundary,'linecolor','m','linewidth',2,...
%  'DisplayName','grain A')
plot(grains(12000,4000).boundary,'linecolor','r','linewidth',2,...
  'DisplayName','grain B')

% stop overide mode
hold off

%%

plot(grains,'linewidth',2)


%%
% Inside of grain B there is a large not indexed region and we might argue
% that is not very meaningfull to assign such a large region to some grain
% but should have kept it not indexed. In order to decide which not indexed
% region is large enaugh to be kept not indexed and which not indexed
% regions can be filled it is helpfull to know that the command calcGrains
% also seperates the not indexed regions into "grains" and we can standard
% grain functions like area or perimeter to analyze these regions.

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd);
notIndexed = grains('notIndexed')

%%
% We see that we have 1139 not indexed regions. A good measure for compact
% regions vs. cluttered regions is the quotient between the area and the
% boundary length.

% plot the not indexed regions colorcoded according the the quotient between
% number of measurements and number of boundary segments
plot(notIndexed,...
  log(notIndexed.grainSize ./ notIndexed.boundarySize))
%colorbar

%%
% Regions with a high quotient are blocks which can be hardly correctly
% assigned to a grain. Hence, we should keep these regions as not indexed
% and only remove the not indexed information from locations with a low
% quotient.

% the "not indexed grains" we want to remove
toRemove = notIndexed(...
  notIndexed.grainSize ./ notIndexed.boundarySize<0.8)

% now we remove the corresponding EBSD measurements
ebsd(toRemove) = []

% and perform grain reconstruction with the reduces EBSD data set
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd);

plot(grains)

%%
% We see that there are some not indexed regions are left blank. Finally,
% the image with the raw EBSD data and on top the grain boundaries.


% plot the raw data
plot(ebsd)

% start overide mode
hold on

% plot the boundary of all grains
plot(grains.boundary,'linewidth',1.5)

% mark two grains by location
plot(grains(11300,6100).boundary,'linecolor','m','linewidth',2,...
  'DisplayName','grain A')
plot(grains(12000,4000).boundary,'linecolor','r','linewidth',2,...
  'DisplayName','grain B')

% stop overide mode
hold off

%% Grain smoothing
% The reconstructed grains show the typicaly staircase effect. This effect
% can be reduced by smoothing the grains. This is particulary important
% when working with the direction of the boundary segments

% plot the raw data
plot(ebsd)

% start overide mode
hold on

% plot the boundary of all grains
plot(grains.boundary,angle(grains.boundary.direction,xvector)./degree,'linewidth',3.5)
%colorbar

% stop overide mode
hold off

%%
% We see that the angle between the grain bounday direction and the x-axis
% takes only values 0, 45 and 90 degree. After applying smoothing we obtain
% a much better result

% smooth the grain boundaries
grains = smooth(grains)

% plot the raw data
plot(ebsd)

% start overide mode
hold on

% plot the boundary of all grains
plot(grains.boundary,...
  angle(grains.boundary.direction,xvector)./degree,'linewidth',3.5)
%colorbar

% stop overide mode
hold off

%% Grain boundaries

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
%oM.colorStretching = 2;
figure(2), plot(oM)

% get the ebsd data of grain 931
ebsd_931 = ebsd(grains(931));

% plot the orientation data
figure(1)
hold on
plot(ebsd_931,oM.orientation2color(ebsd_931.orientations))
hold off


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
