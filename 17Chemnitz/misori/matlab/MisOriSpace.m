

cs1 = crystalSymmetry('121');
cs2 = crystalSymmetry('112');

oR = fundamentalRegion(cs2)

plot(orientationRegion)
hold on
plot(oR,'color','r')

%%

cs1 = crystalSymmetry('3');
cs2 = crystalSymmetry('4');

oR = fundamentalRegion(cs1)

plot(orientationRegion)
hold on
plot(oR,'color','r')
hold off
A = [ 12 -12 0 -368;...
  0 0 17 0;...
  1 1 0  2205;...
  3118 0 0 0];

camview(gca,round(A))

%saveFigure('../pic/oR3a.png')


oR = fundamentalRegion(cs2)

%plot(orientationRegion)
hold on
plot(oR,'color','g')
hold off
camview(gca,round(A))

%saveFigure('../pic/oR4a.png')

oR = fundamentalRegion(cs1,cs2)

%plot(orientationRegion)
hold on
plot(oR,'color','b')
hold off
camview(gca,round(A))

%saveFigure('pic/oR12a.png')

%%

cs1 = crystalSymmetry('3');
cs2 = crystalSymmetry('211');

oR = fundamentalRegion(cs2,cs1)
plot(orientationRegion)
%camview(gca,round(A))
hold on
plot(oR,'color','r')
hold off
%saveFigure('pic/oR321.png')

%%

cs1 = crystalSymmetry('3');
cs2 = crystalSymmetry('222');

oR = fundamentalRegion(cs2,cs1)
plot(orientationRegion)
%camview(gca,round(A))
hold on
plot(oR,'color','r')
hold off
saveFigure('pic/oR622.png')

%%

cs1 = crystalSymmetry('112');
cs2 = crystalSymmetry('112');

oR = fundamentalRegion(cs1)
plot(oR)
oR = fundamentalRegion(cs2,cs1)
%camview(gca,round(A))
hold on
plot(oR,'color','r')
hold off
%saveFigure('pic/oR22.png')

%%

cs1 = crystalSymmetry('3');
cs2 = crystalSymmetry('3');

oR = fundamentalRegion(cs1)
plot(oR)
oR = fundamentalRegion(cs2,cs1)

%camview(gca,round(A))
hold on
plot(oR,'color','r')
hold off
%saveFigure('pic/oR33.png')

%%
cs1 = crystalSymmetry('222');
cs2 = crystalSymmetry('222');

oR = fundamentalRegion(cs1)
plot(oR)
oR = fundamentalRegion(cs1,cs2)
%camview(gca,round(A))
hold on
plot(oR,'color','r')
hold off
%saveFigure('pic/oR2222.png')

%%

cs1 = crystalSymmetry('432');
cs2 = crystalSymmetry('432');

oR = fundamentalRegion(cs1)
plot(oR)
oR = fundamentalRegion(cs1,cs2)
%camview(gca,round(A))
hold on
plot(oR,'color','r')
hold off
%saveFigure('pic/oR4343.png')

%%

cs1 = crystalSymmetry('222');
cs2 = crystalSymmetry('222');

oR = fundamentalRegion(cs1)
plot(oR)
oR = fundamentalRegion(cs1,cs2,'antipodal')
%camview(gca,round(A))
hold on
plot(oR,'color','r')
hold off
%saveFigure('pic/oR2222a.png')

%%

cs1 = crystalSymmetry('432');
cs2 = crystalSymmetry('32');

oR = fundamentalRegion(cs1)
plot(oR)
oR = fundamentalRegion(cs1,cs2)
%camview(gca,round(A))
hold on
plot(oR,'color','r')
hold off

%saveFigure('pic/oR43232a.png')

%%

Mag2Hem = orientation('map', ...
  Miller(1,1,1,cs1), Miller(0,0,0,1, cs2) , ...
  Miller(-1,0,1, cs1), Miller(1,0,-1,0,cs2))

mori = Mag2Hem.symmetrise;
mori = mori(oR.checkInside(mori))

hold on
plot(mori,'MarkerFaceColor','b','MarkerSize',10)
axis off
hold off

%saveFigure('../pic/oR43232b.png')

%%

plotSection(mori,'axisAngle',...
  (45:2:55)*degree,'MarkerFaceColor','r','innnerPlotSpacing',2.5)

%saveFigure('../pic/oR43232Section.pdf','crop')



























%%

cs1 = crystalSymmetry('23');
cs2 = crystalSymmetry('32');

oR = fundamentalRegion(cs2)
plot(oR)
oR = fundamentalRegion(cs1,cs2)
%camview(gca,round(A))
hold on
plot(oR,'color','r')
hold off

%saveFigure('pic/oR2332a.png')

%%

cs1 = crystalSymmetry('23');
cs2 = crystalSymmetry('32');

%%
oR = fundamentalRegion(cs1)
plot(oR)
oR = fundamentalRegion(cs1,cs2)
%camview(gca,round(A))
hold on
plot(oR,'color','r')
hold off

saveFigure('pic/oR2332b.png')

%%

cs = crystalSymmetry('432');

oR = cs.fundamentalRegion;

plot(oR)
hold on
scatter(project2FundamentalRegion(CSL(3,cs)),'markerfacecolor','r','markerSize',10)
scatter(project2FundamentalRegion(CSL(5,cs)),'markerfacecolor','b','markerSize',10)
scatter(project2FundamentalRegion(CSL(7,cs)),'markerfacecolor','g','markerSize',10)
scatter(project2FundamentalRegion(CSL(11,cs)),'markerfacecolor','y','markerSize',10)
axis off
hold off





