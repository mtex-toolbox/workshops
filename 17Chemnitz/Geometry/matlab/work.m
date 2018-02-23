%%

r = vector3d(1,2,3);


plotx2east
plot(r,'upper','grid','on')
annotate([xvector,yvector,zvector],'label',{'X','Y','Z'},...
  'backgroundColor','w')
set(gcf,'position',[200,200,200,200])
saveFigure('pic/vectorEast.pdf')

plotx2north
plot(r,'upper','grid','on')
annotate([xvector,yvector,zvector],'label',{'X','Y','Z'},...
  'backgroundColor','w')
set(gcf,'position',[200,200,200,200])
saveFigure('pic/vectorNorth.pdf')

%%

plotx2east
plot(r,'upper','grid','on','projection','earea')
annotate([xvector,yvector,zvector],'label',{'X','Y','Z'},...
  'backgroundColor','w')
set(gcf,'position',[200,200,200,200])
saveFigure('pic/vectorearea.pdf')

%%

plotx2east
plot(r,'upper','grid','on','projection','eangle')
annotate([xvector,yvector,zvector],'label',{'X','Y','Z'},...
  'backgroundColor','w')
set(gcf,'position',[200,200,200,200])
saveFigure('pic/vectoreangle.pdf')

%%
close all
plot(vector3d(1,1,1),'upper','grid','on');
hold all
plot(vector3d(1,2,3),'label','B');
plot(vector3d(-1,2,1),'label','A');
hold off
set(gcf,'position',[200,200,200,200])

saveFigure('pic/vectorCombined.pdf')

%%
r = randv(100)  % 100 random points
scatter(r,1:100,'upper','grid','on')   % colored by their number
colormap jet
set(gcf,'position',[200,200,200,200])
saveFigure('pic/vectorColor.pdf')

%%

quiver(r,orth(r),'upper','arrowSize',0.08)
set(gcf,'position',[200,200,200,200])
%saveFigure('pic/quiver.pdf')

d = orth(r); d.antipodal = true;
quiver(r,d,'upper','arrowSize',0.08)

%%

mtexdata dubna

plot(pf({1:2}))
mtexColorMap Jet
annotate([xvector,yvector,zvector],'label',{'X','Y','Z'},...
  'backgroundColor','w')
set(gcf,'position',[200,200,200,450])

saveFigure('pic/annotationv.pdf')

%%

odf = calcODF(pf,'zero_range')
q0 = odf.calcModes

plotPDF(odf,pf.allH(1:2))
mtexColorMap white2black

annotate(q0,'label','A','Marker','s','MarkerEdgeColor','w',...
  'backgroundColor','w','MarkerFaceColor','r')
set(gcf,'position',[200,200,200,450])

 saveFigure('pic/annotationq.pdf')
%TODO

%%

r = vector3d(1,1,1,'antipodal')

plot(r,'grid','on','labeled')
annotate([xvector,yvector,zvector],'label',{'X','Y','Z'},...
  'backgroundColor','w')
set(gcf,'position',[200,200,200,390])
saveFigure('pic/vectorAntipodal.pdf')

%%

r = randv(1000);
plot(r,'contourf')
set(gcf,'position',[200,200,200,390])
saveFigure('pic/vectorContour.pdf')
%%

r = randv(1000);
plot(r,'contourf','antipodal','complete')
set(gcf,'position',[200,200,200,390])
saveFigure('pic/vectorContourAntipodal.pdf')

%%

R = rotation.rand(100)

%scatter(R,'markerFaceColor','b')

scatter(R,R.angle./degree,'MarkerSize',10)

mtexColorbar('south')

set(gca,'XTick',0:60:360)
set(gca,'YTick',0:60:180)
set(gca,'ZTick',0:60:360)


%%


scatter(R,R.angle./degree,'MarkerSize',8,'axisAngle')
mtexColorMap jet
hold on
arrow3d(180*[xvector,yvector,zvector])
text3(195*[xvector,yvector,zvector],{'X','Y','Z'})
set(gca,'XDir','rev','YDir','rev')
hold off
set(gcf,'position',[200,200,400,400])

%saveFigure('pic/rotationScatter.pdf')
%saveFigure('pic/rotationScatter.png')

%%

cs = crystalSymmetry('m-3m')

plot(cs,'upper')
set(gcf,'position',[200,200,300,300])
saveFigure('pic/m-3m.pdf')

plotHKL(cs,'upper')
set(gcf,'position',[200,200,200,210])
saveFigure('pic/m-3mHKL.pdf')

cs = crystalSymmetry('m-3m')

%%

cs = loadCIF('quartz')

plot(cs,'upper')
set(gcf,'position',[200,200,300,300])
saveFigure('pic/quartz.pdf')

%plotHKL(cs,'upper')
%set(gcf,'position',[200,200,300,310])
%saveFigure('pic/quartzHKL.pdf')

%%

C = loadPHL('/home/hielscher/mtex/master/data/cif/crystal.phl')


%% 

plot(crystalSymmetry('432'),'upper')
set(gcf,'position',[200,200,300,300])
saveFigure('pic/432.pdf')

plot(crystalSymmetry('-43m'),'upper')
set(gcf,'position',[200,200,300,300])
saveFigure('pic/43m.pdf')

%%

cs = crystalSymmetry('mm2');
a = Miller(1,0,0,cs,'uvw');
plot(cs,'upper')
hold on
plot(a,'MarkerFaceColor','red')
hold off
set(gcf,'position',[200,200,300,300])
saveFigure('pic/mm2.pdf','crop')

cs = crystalSymmetry('m2m');
a = Miller(1,0,0,cs,'uvw');
plot(cs,'upper')
hold on
plot(a,'MarkerFaceColor','red')
hold off
%set(gcf,'position',[200,200,300,300])
saveFigure('pic/m2m.pdf','crop')

cs = crystalSymmetry('2mm');
a = Miller(1,0,0,cs,'uvw');
plot(cs,'upper')
hold on
plot(a,'MarkerFaceColor','red')
hold off
%set(gcf,'position',[200,200,300,300])
saveFigure('pic/2mm.pdf','crop')

%%

names = {'321','3m1','-3m1','312','31m','-31m'};

for i = 1:length(names)
  cs = crystalSymmetry(names{i},'a||x');
  a = Miller(1,0,0,cs,'uvw');
  plot(cs,'upper')
  hold on
  plot(a,'MarkerFaceColor','red')
  set(gcf,'position',[200,200,300,300])
  saveFigure(['pic/sym' names{i} '.pdf'],'crop')
  hold off
end

%%

setMTEXpref('FontSize',15)

cs = crystalSymmetry('-3m1','a||x')

plot(cs,'upper')

h = [Miller(1,0,0,cs),Miller(1,1,1,cs)];
hold on
plot(h(1),'symmetrised','labeled','MarkerFaceColor','r','backgroundcolor','w')
plot(h(2),'symmetrised','labeled','MarkerFaceColor','b','backgroundcolor','w')
set(gcf,'position',[200,200,300,300])
hold off
%saveFigure('pic/hkl.pdf','crop')

%%

plot(cs,'upper')

h = [Miller(1,0,0,cs,'uvw'),Miller(1,1,1,cs,'uvw')];
hold on
plot(h(1),'symmetrised','labeled','MarkerFaceColor','r','backgroundcolor','w')
plot(h(2),'symmetrised','labeled','MarkerFaceColor','b','backgroundcolor','w')
set(gcf,'position',[200,200,300,300])
hold off
%saveFigure('pic/uvw.pdf','crop')

%%

plot(cs,'upper')

h = [Miller(1,0,-1,0,cs,'uvtw'),Miller(1,1,-2,2,cs,'uvtw')];
hold on
plot(h(1),'symmetrised','labeled','MarkerFaceColor','r','backgroundcolor','w')
plot(h(2),'symmetrised','labeled','MarkerFaceColor','b','backgroundcolor','w')
set(gcf,'position',[200,200,300,300])
hold off
%saveFigure('pic/uvtw.pdf','crop')




%%
setMTEXpref('textInterpreter','LaTeX')
plotx2north
m = Miller(1,1,-2,1,cs)
plot(m,'symmetrised','labeled','grid','on','backgroundColor','w')
set(gcf,'position',[200,200,220,430])
saveFigure('pic/MillerSymmetrised.pdf')

%%

cs = crystalSymmetry('mmm',[1 2 3])
m = Miller(-1,1,1,cs,'uvw')
plot(m,'labeled','upper','grid','on')
set(gcf,'position',[200,200,200,200])
saveFigure('pic/MillerUVW.pdf')

%%
hold all
m = Miller(-1,1,1,cs,'hkl')
plot(m,'labeled','upper','grid','on')
set(gcf,'position',[200,200,200,200])
hold off
%saveFigure('pic/MillerHKL.pdf')

%%
hold on
plot(m,'plane','linecolor','r','linewidth',1.5)
hold off
set(gcf,'position',[200,200,200,200])
saveFigure('pic/MillerPlane.pdf')

%%

CS = loadCIF('quartz');
m = Miller(1,1,-2,1,CS)
m.dispStyle = 'UVTW'

round(m)

%%

mtexdata fo
ori = ebsd('Fo').orientations
ori= ori(discretesample(ones(1,length(ori)),200))



%%

figure(1)
plot(ori*Miller(1,0,0,ori.CS),'lower')
set(gcf,'position',[200,200,200,200])
saveFigure('pic/pfSimple.pdf','crop')

%%
figure(2)
plot(ori*symmetrise(Miller(1,0,0,ori.CS)),'lower')

%%

plotPDF(ori,Miller(1,0,0,ori.CS),'upper')
set(gcf,'position',[200,200,300,320])
saveFigure('pic/pfSimple100.pdf','crop')

plotPDF(ori,Miller(0,1,0,ori.CS),'upper')
set(gcf,'position',[200,200,300,320])
saveFigure('pic/pfSimple010.pdf','crop')

%%

plotPDF(ori,Miller(1,0,0,ori.CS),'upper','contourf')
set(gcf,'position',[200,200,300,320])
saveFigure('pic/pfSimple100Smooth.pdf','crop')

plotPDF(ori,Miller(0,1,0,ori.CS),'upper','contourf')
set(gcf,'position',[200,200,300,320])
saveFigure('pic/pfSimple010Smooth.pdf','crop')



%%

plot(symmetrise(inv(ori))*xvector,'upper')
set(gcf,'position',[200,200,200,200])
saveFigure('pic/ipfSimple.pdf','crop')

%%

plotIPDF(ori,xvector)
set(gcf,'position',[200,200,300,320])
saveFigure('pic/ipfSimple100.pdf','crop')

plotIPDF(ori,yvector)
set(gcf,'position',[200,200,300,320])
saveFigure('pic/ipfSimple010.pdf','crop')

%%

plotIPDF(ori,xvector,'contourf')
set(gcf,'position',[200,200,300,320])
saveFigure('pic/ipfSimple100Smooth.pdf','crop')

plotIPDF(ori,yvector,'contourf')
set(gcf,'position',[200,200,300,320])
saveFigure('pic/ipfSimple010Smooth.pdf','crop')

%%

setMTEXpref('FontSize',13)

plotSection(ebsd('Fo').orientations,'phi2',(0:5)*30*degree,'MarkerSize',15)
drawNow(gcm,'figSize','tiny')
%saveFigure('pic/odfOri.pdf','crop')

%%

plotSection(ebsd('Fo').orientations,'phi2',(0:5)*30*degree,'contourf','halfwidth',10*degree)
drawNow(gcm,'figSize','tiny')
%saveFigure('pic/odfOriSmooth.pdf','crop')

%%

oS = omegaSections(ori.CS,ori.SS);
oS.omega = (0:5)*30*degree;
oS.referenceField = @(r) pfSections.sigmaField(r)
plotSection(ebsd('Fo').orientations,oS,'contourf','halfwidth',10*degree)
%saveFigure('pic/odfOriSmoothSigma.pdf','crop')


%%

%oS = axisAngleSections(ori.CS,ori.SS);
%oS.omega = (0:5)*30*degree;
%oS.referenceField = @(r) pfSections.sigmaField(r)
plotSection(ebsd('Fo').orientations,...
  'axisAngle',(10:15:115)*degree,'contourf','halfwidth',10*degree)
%saveFigure('pic/odfOriSmoothAxisAngle.pdf','crop')



%%

oS = orientationRegion;

plot(oS);
saveFigure('pic/oR1.png')

oS = ebsd('Fo').CS.fundamentalRegion;

hold on
plot(oS,'color','r')
hold off
saveFigure('pic/oRmmm.png')

%%

oS = orientationRegion;

plot(oS);

oS = fundamentalRegion(crystalSymmetry('3'));

hold on
plot(oS,'color','r')
hold off
saveFigure('pic/oR3.png')


%%

oS = orientationRegion;

plot(oS);

oS = fundamentalRegion(crystalSymmetry('321'));

hold on
plot(oS,'color','r')
hold off
saveFigure('pic/oR321.png')

%%

oS = orientationRegion;

plot(oS);

oS = fundamentalRegion(crystalSymmetry('432'));

hold on
plot(oS,'color','r')
hold off
saveFigure('pic/oR432.png')



%%

ori = ebsd('Fo').orientations
mean(ori)

%%

mean(angle(mean(ori),ori))./degree

sqrt(mean(angle(mean(ori),ori).^2))./degree


%%

CS_Mag = loadCIF('Magnetite')
CS_Hem = loadCIF('Hematite')
Mag2Hem = orientation('map', ...
  Miller(1,1,1,CS_Mag), Miller(0,0,0,1, CS_Hem) , ...
  Miller(-1,0,1, CS_Mag), Miller(1,0,-1,0,CS_Hem), ...
  CS_Mag, CS_Hem);


O1 = orientation('Euler',0,0,0,CS_Mag);
O2 = O1 * inv(Mag2Hem)


%%

r = O1 * Miller(1,1,1,CS_Mag)

%%

O2 = orientation('Euler',135*degree,55*degree,60*degree,CS_Hem)

round(inv(O2) * r)

%%

MO = inv(O2) * O1

%%


plotIPDF(MO,Miller({0,0,1},{1,1,1},CS_Hem),'complete','upper')

%saveFigure('pic/HemPDF111.pdf','crop')

%%

plotPDF(MO,Miller({1,0,0},{1,1,1},CS_Mag),'complete','upper')
%saveFigure('pic/MagPDF110.pdf','crop')

%%

mtexdata fo

grains = calcGrains(ebsd)

mori = grains.boundary('Fo','Fo').misorientation

%%

axis(MO)



%%

plotAngleDistribution(mori)

hold on
plotAngleDistribution(mori.CS)
hold off

%saveFigure('pic/angleDistri.pdf','crop')

%%

plotAxisDistribution(mori)
%saveFigure('pic/axisDistri.pdf','crop')

%%

plotAxisDistribution(mori,'contourf')
mtexColorbar
%saveFigure('pic/axisDistriSmooth.pdf','crop')


%%

Mag2Hem = orientation('map',...
  Miller(1,1,1,CS_Mag),Miller(0,0,0,1,CS_Hem),...
  Miller(-1,0,1,CS_Mag),Miller(1,0,-1,0,CS_Hem),...
  CS_Mag,CS_Hem)

ori_Hem = orientation('Euler',0,0,0,CS_Hem);
ori_Mag = ori_Hem * symmetrise(Mag2Hem)


%%

O1 = orientation('Euler',90*degree,45*degree,0,CS_Mag)
O2 = orientation('Euler',180*degree,35*degree,0,CS_Hem)

O1 * inv(O1) * O2

%%



%%

O1 * Miller(1,1,1,CS_Mag)

%%

cs = crystalSymmetry('432');
ss = specimenSymmetry('222')

o1 = orientation.goss(cs,ss);
o2 = orientation.brass(cs,ss);

f = fibre(o1,o2)

plot(o1,'markerColor','red','markerSize',10)

saveFigure('../pic/o1.pdf','crop')

%%

hold on
plot(o2,'markerColor','blue','markerSize',10)

saveFigure('../pic/o2.pdf','crop')

%%

plot(f,'linewidth',2)
plot(o1,'markerColor','red','markerSize',10)
plot(o2,'markerColor','blue','markerSize',10)
hold off

%saveFigure('../pic/fibre1.pdf','crop')

%%

f = fibre(o1,o2,'full')


plot(f,'linewidth',2)
hold on
plot(o1,'markerColor','red','markerSize',10)
plot(o2,'markerColor','blue','markerSize',10)

%saveFigure('../pic/fibreFull.pdf','crop')
hold off

%%

plot(f.symmetrise,'linewidth',2)

hold on

plot(o1,'markerColor','red','markerSize',10)

plot(o2,'markerColor','blue','markerSize',10)

%saveFigure('../pic/fibreSym.pdf','crop')

hold off

%%

f = fibre.beta(cs,ss)

hold on
plot(f,'linecolor','g','linewidth',2)

%saveFigure('../pic/fibreBeta.pdf','crop')

hold off

%%

f = fibre(Miller(1,1,1,cs),vector3d.Z)
hold on
plot(f.symmetrise,'linecolor','b','linewidth',2)

%saveFigure('../pic/fibre2.pdf','crop')

%%

odf = fibreODF(fibre.beta(cs,ss),'halfwidth',2.5*degree)

ori = odf.calcOrientations(500)

plot(ori)

f = fibre.fit(ori)

hold on
plot(f)

