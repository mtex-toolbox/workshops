%%

figure('position',[100 100 200 200])
plotx2east
r = vector3d(1,2,3)
plot(r)
hold on
plot([xvector,yvector,zvector],'label',{'X','Y','Z'},'marker','s','MarkerColor','k')
hold off

%%

savefigure('../pic/vectorEast.pdf','crop')

%%

figure('position',[100 100 200 200])
plotx2north
r = vector3d(1,2,3)
plot(r)
hold on
plot([xvector,yvector,zvector],'label',{'X','Y','Z'},'marker','s','MarkerColor','k')
hold off

%%

savefigure('../pic/vectorNorth.pdf','crop')

%%

r = vector3d(1,2,3);
plot(r,'projection','eangle')

savefigure('../pic/vectoreangle.pdf','crop')

%%

r = vector3d(1,2,3);
plot(r,'projection','earea')

savefigure('../pic/vectorearea.pdf','crop')


%%

figure('position',[100 100 400 200])
plotx2north
r = vector3d(1,1,1,'antipodal')
plot(r,'south','north')
hold on
plot([xvector,yvector,zvector],'label',{'X','Y','Z'},'marker','s','MarkerColor','k')
hold off

%%

savefigure('../pic/vectorAntipodal.pdf','crop')

%%

CS = symmetry('3m',[1 1 4])

%%

figure('position',[100 100 400 200])
plotx2north
m = Miller(1,1,1,CS,'uvw')
plot(m,'labeled')


%%

savefigure('../pic/MillerUVW.pdf','crop')

%%

hold all
m = Miller(1,1,1,CS,'hkl')
plot(m,'labeled')
hold off

%%

savefigure('../pic/MillerHKL.pdf','crop')

%%

hold all

circle(m,'color','red')

hold off

savefigure('../pic/MillerPlane.pdf','crop')

%%

symmetrise(m)

%%

figure('position',[100 100 400 200])
m = Miller(1,1,1,CS,'hkl')
plot(m,'symmetrised','labeled','north','grid')
hold off

%%

savefigure('../pic/MillerSymmetrised.pdf','crop')

%%

plot(symmetry('-3m'),'antipodal')

savefigure('../pic/Symmetry.pdf','crop')

%%

v = vector3d(S2Grid('random','points',1000))

%%

figure('position',[100 100 400 200])
plot(v,'antipodal')
savefigure('../pic/vectorScatter.pdf','crop')

%%

figure('position',[100 100 400 200])
plot(v,'contourf')
savefigure('../pic/vectorContour.pdf','crop')

%%

figure('position',[100 100 400 200])
plot(v,'contourf','antipodal')
savefigure('../pic/vectorContourAntipodal.pdf','crop')

%%

figure('position',[100 100 400 200])
plot(R,'north')
savefigure('../pic/rotationNorth.pdf','crop')
figure('position',[100 100 400 200])
plot(R,'south')
savefigure('../pic/rotationSouth.pdf','crop')

close all
%%

figure('position',[100 100 300 300])
plot(C,'north')
savefigure('../pic/symmetryNorth.pdf','crop')

figure('position',[100 100 300 300])
plot(C,'south')
savefigure('../pic/symmetrySouth.pdf','crop')

close all
%%

figure('position',[100 100 250 250])
plot(symmetry('mmm'),'north')
savefigure('../pic/mmmNorth.pdf','crop')

figure('position',[100 100 250 250])
plot(symmetry('mmm'),'south')
savefigure('../pic/mmmSouth.pdf','crop')

close all