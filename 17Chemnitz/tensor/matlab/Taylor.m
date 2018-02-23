% fcc-hcp Shoji-Nishiyama_OR
% Parent = fcc austenite
% Daughter = hcp epsilon martensite

fname = 'twinning2.ctf'

ebsd = loadEBSD(fname,'convertSpatial2EulerReferenceFrame')

ebsd('fcc').CS = ebsd('fcc').CS.properGroup
ebsd('hcp').CS = ebsd('hcp').CS.properGroup
CS_Aus = ebsd('fcc').CS.properGroup
CS_Mar = ebsd('hcp').CS.properGroup

CS_Aus.mineral = 'Austenite (fcc)'
CS_Mar.mineral = 'Martensite (hcp)'

%%

[grains,ebsd.grainId] = calcGrains(ebsd('indexed'))

%%

sS = slipSystem.fcc(CS_Aus);
sS = sS.symmetrise;

% some strain
q = 0.25;
eps = tensor.diag([1 -q -(1-q)],'name','strain')


epsGrain = inv(grains('fcc').meanOrientation).*eps;

[M,b,mori] = calcTaylor(epsGrain,sS);


%%

plot(grains('fcc'),M,'micronbar','off')

mtexColorbar('southoutside')

%saveFigure('../pic/taylor.png')

%%

% index of the most active slip system - largest b
[~,bMaxId] = max(b,[],2);

% rotate the moste active slip system in specimen coordinates
sSGrains = grains('fcc').meanOrientation .* sS(bMaxId);

% visualize slip direction and slip plane for each grain
hold on
quiver(grains('fcc'),sSGrains.b,'autoScaleFactor',0.25,'displayName','Burgers vector')
hold on
quiver(grains('fcc'),sSGrains.n,'autoScaleFactor',0.25,'displayName','slip plane trace')
hold off

%saveFigure('../pic/taylorSlip.png')

%%

grains('fcc').meanOrientation = grains('fcc').meanOrientation .* mori

plot(grains('fcc'),grains('fcc').meanOrientation)

%% Stress based analysis

sigma = stressTensor.diag([1,0,0],'name','stress')

sS = slipSystem.fcc(CS_Aus);
sS = sS.symmetrise('anitpodal');

sSGrains = grains('fcc').meanOrientation * sS

SF = sSGrains.SchmidFactor(sigma);

plot(grains('fcc'),max(SF,[],2),'micronbar','off')
mtexColorbar('southOutside')

saveFigure('../pic/SF.png')

%%


SF = sS.SchmidFactor(inv(grains('fcc').meanOrientation)*sigma);

plot(grains('fcc'),max(SF,[],2),'micronbar','off')
mtexColorbar('southOutside')

[~,id] = max(SF,[],2);

sSGrains = grains('fcc').meanOrientation .* sS(id);

hold on
quiver(grains('fcc'),sSGrains.b,'autoScaleFactor',0.35,'displayName','Burgers vector')
hold on
quiver(grains('fcc'),sSGrains.n,'autoScaleFactor',0.25,'displayName','slip plane trace')
hold off

%saveFigure('../pic/SFSlip.png')


%% -----------------------------------------------------------


% display pole figure plots with RD on top and ND west
plotx2north

storepfA = getMTEXpref('pfAnnotations');
pfAnnotations = @(varargin) text([vector3d.X,-vector3d.Y],{'RD','TD'},...
  'BackgroundColor','w','tag','axesLabels',varargin{:});

setMTEXpref('pfAnnotations',pfAnnotations);



%% Texture evolution during rolling

% define some random orientations
ori = orientation.rand(10000,CS_Aus);


plotPDF(ori,Miller({0,0,1},CS_Aus),'contourf')
mtexColorbar('southoutside')
saveFigure('../pic/rolling001.pdf')

plotPDF(ori,Miller({1,1,1},CS_Aus),'contourf')
mtexColorbar('southoutside')
saveFigure('../pic/rolling111.pdf')

%%

sS = slipSystem.fcc(CS_Aus);

%%
% 30 percent strain
q = 0;
eps = 0.3 * tensor.diag([1 -q -(1-q)],'name','strain');

% 
numIter = 10;
progress(0,numIter);
for sas=1:numIter

  % compute the Taylor factors and the orientation gradients
  [M,~,mori] = calcTaylor(inv(ori) * eps ./ numIter, sS.symmetrise);
  
  % rotate the individual orientations
  ori = ori .* inv(mori);
  progress(sas,numIter);
  
  plotPDF(ori,Miller({0,0,1},CS_Aus),'contourf')
  mtexColorbar('southoutside')
  saveFigure(['../pic/rolling001_' int2str(sas) '.pdf'])

  plotPDF(ori,Miller({1,1,1},CS_Aus),'contourf')
  mtexColorbar('southoutside')
  saveFigure(['../pic/rolling111_' int2str(sas) '.pdf'])
  
end


%%



%%

% plot the resulting pole figures

plotPDF(ori,Miller({0,0,1},{1,1,1},CS_Aus),'contourf')
mtexColorbar

%% restore MTEX preferences

setMTEXpref('pfAnnotations',storepfA);


