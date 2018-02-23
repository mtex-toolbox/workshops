%%

CS_Mag = loadCIF('Magnetite')
CS_Hem = loadCIF('Hematite')
Mag2Hem = orientation('map', ...
  Miller(1,1,1,CS_Mag), Miller(0,0,0,1, CS_Hem) , ...
  Miller(-1,0,1, CS_Mag), Miller(1,0,-1,0,CS_Hem))

O_Mag = orientation('Euler',0,0,0,CS_Mag);
O_Hem = O_Mag * inv(Mag2Hem)


%%





%%

r = O1 * Miller(1,1,1,CS_Mag)

%%

O2 = orientation('Euler',135*degree,55*degree,60*degree,CS_Hem)

round(inv(O2) * r)

%%

MO = inv(O2) * O1

%%

MO.symmetrise('unique')

%%

O_Mag * Mag2Hem.symmetrise('unique')


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

oR = fundamentalRegion(CS_Mag,CS_Hem)
plot(oR)

mori = symmetrise(Mag2Hem,'unique');
mori = mori(oR.checkInside(quaternion(mori)));

hold on
scatter(mori,...
  'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',10)
hold off

axis off

%%

MO = inv(O1) * O2;

[vector3d(axis(MO)),vector3d(axis(inv(MO)))]

%%

angle(O1,O2)./degree
