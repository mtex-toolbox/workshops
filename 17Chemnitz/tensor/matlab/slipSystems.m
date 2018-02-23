cs = crystalSymmetry('432')

b = Miller(0,-1,1,cs ,'uvw');
n = Miller(1,1,1,cs,'hkl') ;
 

sS = slipSystem(b,n)


plot(sS.SchmidFactor,'upper')
mtexColorbar('location','southoutside')

saveFigure('../pic/sFsingle.pdf','crop')

%%

sS = sS.symmetrise('antipodal');

r = plotS2Grid('upper','resolution',0.5*degree)

sF = sS.SchmidFactor(r);


%%

[maxSF,id] = max(abs(sF),[],2);

contourf(r,maxSF,'contours',12)
mtexColorbar('location','southoutside')

saveFigure('../pic/sFsym.pdf','crop')

%%

contourf(r,id,'contours',12)
mtexColorMap white2black

r = symmetrise(cs.Laue.fundamentalSector.center,cs.Laue);
sF = sS.SchmidFactor(r);

[~,id] = max(abs(sF),[],2);

% plot active slip plane in red
hold on
quiver(r,sS(id).n,'ArrowSize',0.075,'LineWidth',2,'Color','r');

% plot active slip direction in green
hold on
quiver(r,sS(id).b,'ArrowSize',0.075,'LineWidth',2,'Color','g');
hold off

saveFigure('../pic/sFactive.pdf','crop')