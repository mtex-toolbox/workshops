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

r = vector3d.rand(1000);
plot(r)

set(gcf,'position',[200,200,200,390])
%saveFigure('pic/vectorScatter.pdf')

%%

plot(r,'contourf')
set(gcf,'position',[200,200,200,390])
saveFigure('pic/vectorContour.pdf')
%%

r = randv(1000);
plot(r,'contourf','antipodal','complete')
set(gcf,'position',[200,200,200,390])
saveFigure('pic/vectorContourAntipodal.pdf')


%%
r = randv(100)  % 100 random points
scatter(r,r.rho./degree,...
  'upper','grid','on','minmax')   % colored by their number
set(gcf,'position',[200,200,230,230])
mtexColorbar('southoutside')
mtexColorMap jet

%saveFigure('pic/vectorColor.pdf')


%%

oM = ipdfHSVOrientationMapping

scatter(r,oM.Miller2color(r),...
  'upper','grid','on','minmax')   % colored by their number
set(gcf,'position',[200,200,200,200])

%saveFigure('pic/vectorRGBColor.pdf')


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



%%



