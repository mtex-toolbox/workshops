M = [[1.45 0.00 0.19];...
     [0.00 2.11 0.00];...
     [0.19 0.00 1.79]];

sigma = tensor(M,'name','stress','unit','MPa');

%%

R = sigma.directionalMagnitude


%%

plot(sigma,'minmax')
mtexColorMap blue2red
set(gcf,'Renderer','painters')
%saveFigure('../pic/sigma.pdf')

%%

R = sigma.directionalMagnitude
[value,pos] = min(R)
annotate(pos)
saveFigure('../pic/sigmaMin.pdf')


%%

CS = crystalSymmetry('32', [4.916 4.916 5.4054], 'X||a*', 'Z||c', 'mineral', 'Quartz');

fname = fullfile(mtexDataPath,'tensor', 'Single_RH_quartz_poly.P');

P = loadTensor(fname,CS,'propertyname','piecoelectricity','unit','C/N','interface','P','DoubleConvention')

plot(P,'minmax','complete','upper')
mtexColorMap blue2red
set(gcf,'Renderer','painters')
%saveFigure('../pic/piezoComplete.pdf')

%%


ori = orientation('Euler',10*degree,20*degree,0,CS)

rotate(P,ori)

rotate(sigma,inv(ori))



%%

plot(P,'minmax')
mtexColorMap blue2red
set(gcf,'Renderer','painters')
%saveFigure('../pic/piezo.pdf')

%%

cs = crystalSymmetry('monoclinic', [8.561, 12.996, 7.192], [90, 116.01, 90] * degree, ...
  'mineral', 'orthoclase', 'Y||b', 'Z||c');

M = [[ 1.45 0.00 0.19]; ...
  [0.00 2.11 0.00]; ...
  [0.19 0.00 1.79]] ;

k = tensor(M, 'name', 'thermalconductivity', 'unit', 'W1/m1/K', cs)

plot(k,'complete','upper')

%%

mtexdata csl

sigma = tensor([[0 0 0];[0 0 0];[0 0 1]],'name','stress')

grains = calcGrains(ebsd)

%%

sigmaCS = rotate(sigma,inv(grains.meanOrientation))

sS = slipSystem.fcc(grains.CS)
sS = sS.symmetrise;

SF = sS.SchmidFactor(sigmaCS);

plot(grains,max(SF,[],2))



