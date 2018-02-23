% fcc-hcp Shoji-Nishiyama_OR
% Parent = fcc austenite
% Daughter = hcp epsilon martensite

fname = 'twinning2.ctf'

ebsd = loadEBSD(fname,'convertSpatial2EulerReferenceFrame')


%%


plot(ebsd('fcc'),ebsd('fcc').orientations)

hold on
plot(ebsd('hcp'),'facecolor',0.5*[1 1 1]);
plot(ebsd('bcc'),'facecolor',0.8*[1 1 1]);
hold off

%saveFigure('../pic/twinRaw.png')


%%

[grains, ebsd.grainId] = calcGrains(ebsd,'threshold',5*degree);

grains = smooth(grains)

hold on
plot(grains.boundary)
hold off

%saveFigure('../pic/twinGrains.png')

%%

gB = grains.boundary('fcc','hcp')
plotSection(gB.misorientation,'MarkerEdgeColor','b','all',...
  'axisAngle',(20:5:55)*degree,'MarkerFaceColor','none','innerPlotSpacing',2.5)

%saveFigure('../pic/twinSections.pdf')


%%
mdf = calcMDF(gB.misorientation)

plotSection(mdf,'axisAngle',(20:5:55)*degree,'innerPlotSpacing',2.5)

%saveFigure('../pic/MDFSections.pdf')

%%

oR = fundamentalRegion(gB.misorientation);

plot(oR)
hold on
scatter(gB.misorientation.project2FundamentalRegion,...
  mdf.eval(gB.misorientation))
axis off
hold off

%saveFigure('../pic/oRTwin.png')


%% Plot the boundary misorientation distribution map

% plot (gB_alpha_epsilon)
plot(ebsd('fcc'),'faceColor',0.8*[1 1 1])%,'facealpha',0.5)
hold on
plot(ebsd('hcp'),'faceColor',0.5*[1 1 1])%,'facealpha',0.5)
plot(grains.boundary)

plot(gB,gB.misorientation.angle./degree,'linewidth',2)
hold off

mtexColorMap 
mtexColorbar('southOutside')

%saveFigure('../pic/gBAngle.png')


%% detect twinnings

oR = fundamentalRegion(gB.CS{1},gB.CS{2},'ignoreCommonSymmetries')

plot(oR)

twinMori = unique(orientation(oR.V,gB.misorientation.CS,gB.misorientation.SS))

twinMori.angle / degree

%%

sum(gB.isTwinning(twinMori(3),1*degree))


% plot (gB_alpha_epsilon)
plot(ebsd('fcc'),'faceColor',0.8*[1 1 1])%,'facealpha',0.5)
hold on
plot(ebsd('hcp'),'faceColor',0.5*[1 1 1])%,'facealpha',0.5)
plot(grains.boundary)

plot(gB(gB.isTwinning(twinMori,1*degree)),'linecolor','r','linewidth',2)


hold off

%saveFigure('../pic/twinBoundary.png')

%% Recover austenite grains

[grainMerged,parentId] = merge(grains,gB(gB.isTwinning(twinMori,1*degree)));

% set all merged grains to Austenite
%grainMerged.phase(parentId(grains.phase==1)) = 1;


%%

hold on
plot(grainMerged.boundary,'linecolor','b','linewidth',2)
hold off

%saveFigure('../pic/grainMerged.png')

%%

plot(grainMerged)
%saveFigure('../pic/grainMergeda.png')

%%

plotAngleDistribution(gB.misorientation,...
  'resolution',1*degree,'DisplayName','fcc-hcp');

hold on
% the untextured (random) misorientation distribution
plotAngleDistribution(gB.misorientation.CS,gB.misorientation.SS,...
  'DisplayName','Untextured')
hold off




%%

% %--- Calculate the misorientation angle of the interface in the lower symmetry crystal reference frame
anglz = gB_gamma_epsilon.misorientation.angle./degree;
anglz_range = gB_gamma_epsilon_range.misorientation.angle./degree;
%--- Define the class interval and range
% class_interval = 0.5;
class_range = [0:class_interval:120]; 
%--- Get the number of absolute counts in each class interval
abs_counts = histc(anglz',class_range);
%--- Normalise the absolute counts in each class interval
norm_counts = 100.*(abs_counts./sum(abs_counts));
%--- Plot the bar graph based on class specifications
figure (3)
bar(class_range, norm_counts, 'histc');
set(gca, 'xlim',[class_range(1) class_range(end)]);
%--- Annotate the graph axes and title
xlabel('Misorientation (degrees)','FontSize',14);
ylabel('Frequency (%)', 'FontSize',14);
title('Experimental interphase misorientation distribution','FontSize',14);
%--- Output the data onto the command window
anglz_xy_data = [class_range', norm_counts'];

idx = find(anglz_xy_data(:,2)>0);
%anglz_xy_data(idx,:)


%%

%--- Plot the user-defined angular misorientation range in the misorientation axis distribution
figure (4)
plotAxisDistribution(gB_gamma_epsilon_range.misorientation,ProjectionSystem,'fundamentalRegion','projection','earea','symmetrised','antipodal','smooth');
% plotAxisDistribution(gB_gamma_epsilon_range.misorientation,ProjectionSystem,'projection','earea','symmetrised','antipodal','MarkerSize',12,'MarkerColor', [0 0 0]);
hold on
%--- Plot the corners of the misorientation axis distribution in unique colors
h2 = Miller({1,0,-1,0},{1,1,-2,0},{0,0,0,1},cs_hcp,ProjectionSystem);
for ii = 1:length(h2)
    plot(h2(ii),'fundamentalRegion','projection','earea','symmetrised','antipodal','labeled','MarkerSize',10)
end
hold off

axz = [gB_gamma_epsilon_range.misorientation.axis.h, gB_gamma_epsilon_range.misorientation.axis.k, gB_gamma_epsilon_range.misorientation.axis.i, gB_gamma_epsilon_range.misorientation.axis.l];
% axz

%--- Define the angular misorientation range to display in the misorientation axis distribution
min_anglz = 0
max_anglz = 120
%--- Define the class interval for the histogram (NOTE: Reduce to small bins (say 0.005) to
%find out the exact angle)
class_interval = 0.005;

%%

hist(grains.boundary('fcc','fcc').misorientation.angle./degree)

%saveFigure('../pic/histAngleSimple.pdf')

%%

%saveFigure('../pic/histAngle.pdf')


%%

plotAngleDistribution(grains.boundary('fcc','fcc').misorientation,'resolution',3*degree)
hold on
plotAngleDistribution(grains.boundary('fcc','hcp').misorientation,'resolution',3*degree)
plotAngleDistribution(grains.boundary('bcc','hcp').misorientation,'resolution',3*degree)
hold off
%legend('--display','location','northwest')

saveFigure('../pic/histAngleCombined.pdf')

%%

odfFCC = calcODF(ebsd('fcc').orientations,'halfwidth',5*degree)
MDF = calcMDF(odfFCC)
hold all
plotAngleDistribution(MDF)
hold off
%saveFigure('../pic/angleDistriMDF1.pdf')

%%

MDF = uniformODF(MDF.CS,MDF.SS)
hold all
plotAngleDistribution(MDF)
hold off

%saveFigure('../pic/angleDistriUniform.pdf')

%%

MDF2 = calcMDF(grains.boundary('fcc','fcc').misorientation,'halfwidth',5*degree)
hold all
plotAngleDistribution(MDF2)
hold off
%saveFigure('../pic/angleDistriMDF2.pdf')

%%

dCS = Laue(disjoint(MO.CS,MO.SS));
MO = inv(O2)*O1

plot(MO.axis,'markerFaceColor','r','upper','MarkerSize',15,'xAxisDirection',0)
hold on
%plot(Miller(MO.axis,dCS.Laue),'symmetrised','upper','MarkerSize',12)
plot(MO.axis,'symmetrised','upper')
hold off


hold on
plot(dCS)
hold off

text(MO.SS.aAxis,'a','Backgroundcolor','w','FontSize',20)
text(xvector,'X','Backgroundcolor','w')
%saveFigure('../pic/misAxisa.pdf')

%%

MOi = inv(MO)
plot(MOi.axis,'markerFaceColor','r','upper','MarkerSize',15,'xAxisDirection',0)
hold on
%plot(Miller(MOi.axis,dCS.Laue),'symmetrised','upper','MarkerSize',12)
plot(MOi.axis,'symmetrised','upper')
hold off
hold on
plot(dCS)
hold off
text(MO.CS.aAxis,'a','Backgroundcolor','w','FontSize',20)

%saveFigure('../pic/misAxisb.pdf')

%%
plot(axis(O1,O2),'upper')

%saveFigure('../pic/misAxisc.pdf')

%%

oriFCC = ebsd(gB.ebsdId(:,1)).orientations
oriHCP = ebsd(gB.ebsdId(:,2)).orientations

%plotAxisDistribution(oriFCC,oriHCP,'MarkerSize',5,'MarkerFaceColor',...
%  'none','MarkerEdgecolor','k','contourf','minmax','colorRange',[1,260])

plotAxisDistribution(oriFCC,oriHCP,'MarkerSize',5,'MarkerFaceColor',...
  'none','MarkerEdgecolor','k')

mtexColorMap LaboTeX

%saveFigure('../pic/AxisSample1.pdf')

%%

figure(1)
plotAxisDistribution(gB.misorientation,'noLabel','figSize','tiny')
saveFigure('../pic/AxisDistri1.pdf')
mtexColorMap LaboTeX
figure(2)
plotAxisDistribution(inv(gB.misorientation),'noLabel','figSize','tiny')
mtexColorMap LaboTeX
saveFigure('../pic/AxisDistri2.pdf')


%%

figure(1)
plotAxisDistribution(gB.misorientation,'noLabel','figSize','tiny','contourf')
mtexColorMap LaboTeX
mtexColorbar('southoutSide')
%saveFigure('../pic/AxisDistri3.pdf')
figure(2)
plotAxisDistribution(inv(gB.misorientation),'noLabel','figSize','tiny','contourf')
mtexColorMap LaboTeX
mtexColorbar('southoutSide')
%saveFigure('../pic/AxisDistri4.pdf')

%%

%%

mdf2 = calcMDF(gB.misorientation,'halfwidth',5*degree)

%%

plotAxisDistribution(mdf,'xAxisDirection',0,'figSize','tiny','noLabel')
mtexColorbar('southoutSide')
mtexColorMap LaboTeX

set(gcf,'renderer','painters');
%saveFigure('../pic/mdfAxis3.pdf')

%%

hold on
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',10)
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',11)
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',12,'figSize','tiny')
hold off

set(gcf,'renderer','painters');
%saveFigure('../pic/mdfAxis3M.pdf')

%%

plotAxisDistribution(gB.CS{1},gB.CS{2},'noLabel','xAxisDirection',0,'figSize','tiny')
mtexColorbar('southoutSide')
mtexColorMap LaboTeX
set(gcf,'renderer','painters');
%saveFigure('../pic/mdfAxis.pdf')
%%

hold on
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',11)
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',12)
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',10,'figSize','tiny')
hold off

set(gcf,'renderer','painters');
%saveFigure('../pic/mdfAxisM.pdf')


%%


%[value,mori] = max(mdf)

hold on
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',15)
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',14)
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',12)
hold off

saveFigure('../pic/mdfAxis2.pdf')

%%

odfHCP = calcODF(ebsd('HCP').orientations,'halfwidth',5*degree)

mdf = calcMDF(odfHCP,odfFCC)

%%

plotAxisDistribution(mdf,'xAxisDirection',0,'figSize','tiny','noLabel')
mtexColorbar('southoutSide')
mtexColorMap LaboTeX

set(gcf,'renderer','painters');
%saveFigure('../pic/mdfAxis4.pdf')

%%

hold on
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',10)
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',11)
plot(mori.axis,'MarkerFaceColor','none','MarkerEdgeColor','g','MarkerSize',12,'figSize','tiny')
hold off

set(gcf,'renderer','painters');
%saveFigure('../pic/mdfAxis4M.pdf')
