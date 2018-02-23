%
% Lets import some iron data and segment grains within the data set.
mtexdata csl

poly = [0 0 500 150]
ebsd = ebsd(ebsd.inpolygon(poly));

plot(ebsd,ebsd.orientations)
%set(gcf,'renderer','opengl')
%saveFigure('../pic/EBSDCSL.png')

%%

% grain segementation
[grains,ebsd.grainId] = calcGrains(ebsd)

% grain smoothing
grains = smooth(grains,2) 

% plot the result
plot(grains,grains.meanOrientation)

%set(gcf,'renderer','opengl')
%saveFigure('../pic/EBSDGrains.png')

%%

plot(ebsd,ebsd.KAM)
mtexColorMap LaboTeX
hold on 
plot(grains.boundary)
hold off


%set(gcf,'renderer','painters')
%saveFigure('../pic/EBSDKAM.png')

%%

hold on
plot(grains(90).boundary,'linewidth',2,'color','b')
hold off

%set(gcf,'renderer','painters')
%saveFigure('../pic/grainBoundary.png')

%%
% Next we plot image quality as it makes the grain boundaries visible.

plot(ebsd,log(ebsd.prop.iq))
mtexColorMap black2white
CLim(gcm,[.5,5])

% and overlay it with the orientation map
hold on
plot(grains,grains.meanOrientation,'FaceAlpha',0.6)
hold off

%% Detecting CSL Boundaries
% In order to detect CSL boundaries within the data set we first restrict
% the grain boundaries to iron to iron phase transitions and check then
% the boundary misorientations to be a CSL(3) misorientation with threshold
% of 3 degree.

% restrict to iron to iron phase transition
gB = grains.boundary('iron','iron')

% select CSL(3) grain boundaries
gB3 = gB(angle(gB.misorientation,CSL(3)) < 3*degree);

% overlay CSL(3) grain boundaries with the existing plot
hold on
plot(gB3,'lineColor','g','linewidth',2,'DisplayName','CSL3')
hold off

%set(gcf,'renderer','painters')
saveFigure('../pic/grainCSL3.png')

%% Merging grains with common CSL(3) boundary
% Next we merge all grains together which have a common CSL(3) boundary.
% This is done with the command <grain2d_merge.html merge>.

% this merges the grains
[mergedGrains,parentIds] = merge(grains,gB3);

% overlay the boundaries of the merged grains with the previous plot
hold on
plot(mergedGrains.boundary,'linecolor','w','linewidth',2)
hold off
%set(gcf,'renderer','painters')
saveFigure('../pic/grainMerged.png')

%%
% Finaly, we check for all other types of CSL boundaries and overlay them
% with our plot.

delta = 5*degree;
gB5 = gB(gB.isTwinning(CSL(5),delta))
gB7 = gB(gB.isTwinning(CSL(7),delta))
gB9 = gB(gB.isTwinning(CSL(9),delta))
gB11 = gB(gB.isTwinning(CSL(11),delta))

hold on
plot(gB5,'lineColor','b','linewidth',2,'DisplayName','CSL 5')
hold on
plot(gB7,'lineColor','r','linewidth',2,'DisplayName','CSL 7')
hold on
plot(gB9,'lineColor','m','linewidth',2,'DisplayName','CSL 9')
hold on
plot(gB11,'lineColor','c','linewidth',2,'DisplayName','CSL 11')
hold off

%% Colorizing misorientations 
%

oM = patalaOrientationMapping(gB)

plot(ebsd,log(ebsd.prop.iq),'figSize','large','FaceAlpha',0.2)
mtexColorMap black2white
CLim(gcm,[.5,5])

% and overlay it with the orientation map
hold on
plot(grains,grains.meanOrientation,'FaceAlpha',0.2)

hold on
plot(gB,oM.orientation2color(gB.misorientation),'linewidth',2)
hold off


%%
% The corresponding colormap is shown by

plot(oM,'axisAngle',(5:5:60)*degree)

hold on
plot(gB.misorientation,'points',300,...
  'MarkerFaceColor','none','MarkerEdgeColor','w')
hold off

%%

plotAngleDistribution(grains.boundary('indexed').misorientation,...
  'displayName','iron - iron','resolution',2.5*degree)
hold on
plotAngleDistribution(ebsd.CS,'DisplayName','random')
hold off

saveFigure('../pic/angleDistri.pdf')
%%

grains('indexed').boundary.plotAxisDistribution('contourf')
mtexColorbar
drawNow(gcm)
saveFigure('../pic/axisDistri.pdf')


%%

mdf = calcODF(gB.misorientation,'halfwidth',2.5*degree)


%%

plot(mdf,'axisAngle',[35 40 50 60]*degree,'colorRange',[0 15],'contourf','resolution',1*degree)

annotate(CSL(3),'label','$CSL_3$','backgroundcolor','w','autoAlignText')
annotate(CSL(5),'label','$CSL_5$','backgroundcolor','w','autoAlignText')
annotate(CSL(7),'label','$CSL_7$','backgroundcolor','w','autoAlignText')
annotate(CSL(9),'label','$CSL_9$','backgroundcolor','w','autoAlignText')

drawNow(gcm)

%set(gcf,'renderer','painters')
%saveFigure('../pic/MDF.pdf','crop')

%%

mori = mdf.calcModes(2)

%%

volume(gB.misorientation,CSL(3),2*degree)

%volume(mdf,CSL(3),2*degree) % 0.78 --- seems to be wrong

volume(gB.misorientation,CSL(9),2*degree)


%%

%annotate(mori(2),'markerFaceColor','r')

%%

omega = linspace(0,55*degree);
fibre100 = orientation('axis',xvector,'angle',omega,mdf.CS,mdf.SS)
fibre111 = orientation('axis',vector3d(1,1,1),'angle',omega,mdf.CS,mdf.SS)
fibre101 = orientation('axis',vector3d(1,0,1),'angle',omega,mdf.CS,mdf.SS)

plot(omega ./ degree,mdf.eval(fibre101))

%%

mori = orientation('Euler',15*degree,28*degree,14*degree,mdf.CS,mdf.CS)

mdf.eval(mori)


%%


CS_Mag = loadCIF('Magnetite')
CS_Hem = loadCIF('Hematite')

Mag2Hem = orientation('map',...
  Miller(1,1,1,CS_Mag),Miller(0,0,0,1,CS_Hem),...
  Miller(-1,0,1,CS_Mag),Miller(1,0,-1,0,CS_Hem))

ori_Mag = orientation('Euler',0,0,0,CS_Mag)
ori_Hem = ori_Mag * symmetrise(inv(Mag2Hem))

plotPDF(ori_Hem,...
  [Miller(1,0,0,CS_Hem),Miller(1,1,0,CS_Hem),...
  Miller(0,0,1,CS_Hem),Miller(1,1,1,CS_Hem)])


saveFigure('../pic/HemPF.pdf')

%%

plotPDF(ori_Hem,...
  [Miller(1,0,0,CS_Hem),Miller(1,1,0,CS_Hem),...
  Miller(0,0,1,CS_Hem),Miller(1,1,1,CS_Hem)])

%% plastic deformation

cs = ebsd.CS

%
%% define the slip system
% by convention 
% b = slip direction [uvw] in the slip plane (hkl) 
% n = slip plane normal(hkl)
% angle b to n = 90 degrees and b.n = 0
%
% define the slip direction and slip plane normal
b = Miller(0,-1,1,cs,'uvw'); % slip direction [uvw] in the slip plane (hkl)
n = Miller(1,1,1,cs,'hkl');  % slip plane normal (hkl)
% check that b and n are orthogonal
Angle_b_to_n = angle(vector3d(b),vector3d(n))/degree

%% define extension direction
% a normal stress extension direction in specimen co-ordinates
r = vector3d(0,0,1)

%% compute Schmid factor directly

% Schmid factor for slip plane normal (n) and slip direction (b) for
% direction r
Schmid_factor = dot(n,r) * dot(b,r)

%% compute Schmid factor using Schmid tensor
% alternativly we can define the Schmid tensor and stress tensor
% schmid factor for slip plane normal (n) and slip direction (b)
Schmid_tensor = SchmidTensor(n,b)

% define stress components of the tensor
% e.g. Uniaxial stress along the Z specimen direction
M =.... 
 [[  0.00   0.00    0.00];...
 [   0.00   0.00    0.00];...
 [   0.00   0.00    1.00]];

% define MTEX stress tensor
sigma = tensor(M,'name','stress')

% the Schmid factor may be computed as tensor product Schmid_tensor(i,j) *
% sigma(i,j)
Schmid_factor = double(EinsteinSum(Schmid_tensor,[-1,-2],sigma,[-1,-2]))

%% Schmid factor for a list of tension directions
% the above computation can be easily extended to a list of tension
% directions

% define grid of tension directions
r = plotS2Grid('resolution',0.5*degree,'upper')

% define the coressponding list of normal stress tensors
sigma = EinsteinSum(tensor(r),1,tensor(r),2,'name','stress tensor')

% compute the Schmid factors for all normal stress directions
Schmid_factor_hemisphere = double(...
  EinsteinSum(Schmid_tensor,[-1,-2],sigma,[-1,-2],'name','Schmid factor'));

% plot the Schmid factors
contourf(r,Schmid_factor_hemisphere)
mtexColorMap blue2red
colorbar

%% Finding the active slip system 
%
% With slip direction b and slip plane n also all crystallographic
% symmetric directions and planes which are orthogonal are valid slip
% systems. Let us determine those equivalent slip systems by
% symmetrising b and n

[bSym,l] = symmetrise(b,'antipodal');
[nSym,l] = symmetrise(n,'antipodal');

% restrict b and n to pairs of orthogonal vectors
[row,col] = find(isnull(dot_outer(vector3d(bSym),vector3d(nSym))));
bSym = bSym(row)
nSym = nSym(col)
%
% vizualize crystallographic symmetric slip systems
plot(bSym,'antipodal')
hold all
plot(nSym)
hold off

%% compute Schmid factors for all these slip systems

% define a stress tensor with normal stress in 001 direction
M = zeros(3);M(3,3) = 1;
sigma001 = tensor(M,'name','stress')

% and rotate it a bit
sigmaRot = rotate(sigma001,...
  rotation('Euler',20*degree,20*degree,-30*degree))

% define a list of Schmid tensors - one for each slip sytem
RSym = SchmidTensor(bSym,nSym)

% compute a list Schmid factors - one for each slip system
Schmid_Factor_List = double(...
  EinsteinSum(RSym,[-1,-2],sigmaRot,[-1,-2],'name','Schmid factor'))
[Schmid_Max,ind] = max(Schmid_Factor_List)

% we observe that the Schmid factor is always between -0.5 and 0.5.
% The largest value indicates the active slip system. 
% In the above case this would be the slip system found by ind 
Active_Slip_Direction = bSym(ind)
Active_Slip_Plane = nSym(ind)

%% Finding the active slip system 
%
% All the above steps for finding the active slip system,
% i.e.
% * find all symmetrically equivalent slip systems
% * compute all the Schmid factors
% * find the maximum Schmid factor find the corresponding slip system 
%
% can be preformed by the single command calcShearStress
% the output is
%
% * Schmid_Max - maximum Schmid factor
% * bActive    - active slip direction
% * nActive    - active slip normal
% * tau        - all schmid factors [number of slipSystems x number of stress tensors]
% * ind        - index of the active slip system

[Schmid_Max,bActive,nActive,tau,ind] = ...
  calcShearStress(sigmaRot,n,b,'symmetrise')

%%
% This command allows also to compute the maximum Schmidt factor
% and the active slip system for a list of stress tensors in parallel. 
% Consider again the list of normal stress tensors corresponding
% to any direction sigma

sigma

% Then we can compute the maximum Schmid factor and 
% the active slip system for all these stress tensors by the single command
[Schmid_Max,bActive,nActive,tau,ind] = ...
  calcShearStress(sigma,n,b,'symmetrise');

%%
% plot the maximum Schmid factor
contourf(r,abs(Schmid_Max));

colorbar(gcm)

%savefigure('../tensor/pic/SFMax.pdf')

%% Plot the index of the active slip system

pcolor(r,ind)
mtexColorMap black2white

% We can even visualize the active slip system
% take as directions the centers of the fundamental sectors
r_Center = symmetrise(cs.fundamentalSector.center,cs);

% generate stress tensors
sigma = EinsteinSum(tensor(r_Center),1,r_Center,2)
%sigma = EinsteinSum(tensor(r),1,tensor(r),2) ?

% compute active slip system
[tauMax,bActive,nActive] = calcShearStress(sigma,n,b,'symmetrise');
bActive(tauMax<0) = -bActive(tauMax<0);

hold on
% plot active slip plane in red
quiver(r_Center,bActive,'ArrowSize',0.15,'LineWidth',2,'Color','r',...
  'DisplayName','slip normal');

% plot active slip direction in green
quiver(r_Center,nActive,'ArrowSize',0.15,'LineWidth',2,'Color','g',...
  'DisplayName','slip direction');
hold off

%savefigure('../tensor/pic/SFActive.pdf')

legend('location','northeast')
drawNow(gcm,'figSize','large')


%%
% The above procedure may also be applied to grains which has the advantage
% to be much less computational demanding for large data sets.
%
% compute grains

% transform the stress tensor from specimen to crystal coordinates
sigmaCS = rotate(sigma001,inv(grains.meanOrientation))

% compute maximum Schmid factor and active slip system
[Schmid_Max,bActive,nActive,tau,ind] = calcShearStress(sigmaCS,n,b,'symmetrise');

plot(grains,abs(Schmid_Max))
colorbar(gcm)

set(gcf,'renderer','painter')
saveFigure('../pic/shearStress.pdf')

%% We may also colorize the active slip system.

close all

colorOrder = get(gca,'colorOrder');

% consider only present slips systems
presentSystems = unique(ind);

% cycle through slip systems and plot them
for i = 1:length(presentSystems)
  
  id = presentSystems(i);
  plot( grains(ind==id) , 'FaceColor', colorOrder(i,:),...
    'DisplayName',[char(nSym(id)) ' ' char(bSym(id))]);  
  hold all
  
end

plot(grains.boundary)
hold off

legend('show')
drawNow(gcm)

set(gcf,'renderer','openGL')
saveFigure('../pic/slipSystem.pdf')

%% --------------------------------------------

cs = crystalSymmetry('432', [3.5451 3.5451 3.5451],'mineral', 'Ni');

mtexFig = mtexFigure;

for s = -10:5:10

  if s>-10, mtexFig.nextAxis; end
  
  odf = BinghamODF(20*[-10,-10,s,10],quaternion(eye(4)),cs)

  plotPDF(odf,Miller(1,0,0,cs),'parent',mtexFig.gca);
  
  mtexTitle(mtexFig.gca,['$\lambda_3 = ' int2str(s) '$'])
    
end

mtexFig.drawNow

%saveFigure('../pic/binghamPDF.pdf')


%% Define elastic property

pname = 'data_tensor';
fname = [pname filesep 'IN739LC.GPa'];

C = loadTensor(fname,cs,'name','elastic stiffness','unit','GPa','interface','generic')

figure('position',[0 0 500 400])
plot(C,'plotType','YoungsModulus','3d','complete');
colorbar;
colormap jet
axis off
%saveFigure('../pic/Nickel_SC_3d.pdf')

figure('position',[0 0 500 400])
plot(C,'plotType','YoungsModulus','contourf',120:20:300,'projection','stereo','complete','upper')
%annotate([xvector,-yvector,zvector],'label',{'010','100','001'},'color','k','backgroundcolor','w');
colormap jet;
mtexColorbar;
%saveFigure('../pic/Nickel_SC_2d.pdf')

%%

M = zeros(3);
M(3,3) = 1;

sigma = tensor(M,'name','stress')

EinsteinSum(C,[-1 -2 1 2],sigma,[-1 -2])

%%

x = plotS2Grid('upper');
nu = C.PoissonRatio(x,xvector);

contourf(x,nu,'minmax')
mtexColorMap blue2red

set(gcf,'Renderer','painters')
%saveFigure('../pic/PRa.pdf')

[value,id] = max(nu)

%%

annotate(x(id),'label','max')

%saveFigure('../pic/PRb.pdf')



%% Voigt / Reuss / Hill bounds

psr_vx = [];
psr_rx = [];
psr_v1 = [];
psr_r1 = [];
psr_v2 = [];
psr_r2 = [];

for s = -10:0.5:10

  odf = BinghamODF(20*[-10,-10,s,10],quaternion(eye(4)),cs);

  [C_v,C_r] = calcTensor(odf,C,'quadrature');
  
  psr_vx(end+1) = C_v.YoungsModulus(zvector);
  psr_rx(end+1) = C_r.YoungsModulus(zvector);
  psr_v2(end+1) = C_v.YoungsModulus(vector3d(0,1,1));
  psr_r2(end+1) = C_r.YoungsModulus(vector3d(0,1,1));
  psr_v1(end+1) = C_v.YoungsModulus(vector3d(1,1,1));
  psr_r1(end+1) = C_r.YoungsModulus(vector3d(1,1,1));
    
end


%%

plot(-10:0.5:10,psr_vx,'DisplayName','Voigt bound')
hold all
plot(-10:0.5:10,psr_rx,'DisplayName','Reuss bound')
hold off

%saveFigure('../pic/VR.pdf')

%%


figure('position',[0 0 500 400])
plot(C_v,'plotType','YoungsModulus','contourf',120:20:300,'projection','stereo');
annotate([xvector,-yvector,zvector],'label',{'P','T','B'});
colormap('jet')
%saveFigure('Voigt.pdf')
colorbar;



% isotropic Voigt bounds
cijij = double(EinsteinSum(C_v,[-1 -2 -1 -2]));
ciijj = double(EinsteinSum(C_v,[-1 -1 -2 -2]));
lambda_v = (2*ciijj - cijij)/15;
mue_v = (-ciijj + 3*cijij)/30;
E_v = mue_v *(2*mue_v + 3*lambda_v) / (mue_v + lambda_v)

% Reuss tensor
S_r = inv(C_r)
figure('position',[0 0 500 400])
plot(C_r,'plotType','YoungsModulus','contourf',120:20:300,'projection','stereo');
annotate([xvector,-yvector,zvector],'label',{'P','T','B'});
colormap('jet')
%saveFigure('Reuss.pdf')
colorbar;

% isotropic Reuss bounds
sijij = double(EinsteinSum(S_r,[-1 -2 -1 -2]));
siijj = double(EinsteinSum(S_r,[-1 -1 -2 -2]));
E_r = 15 / (siijj + 2*sijij)
mue_r = 7.5 / (-siijj + 3*sijij);

%% profile BT
ang = 0.0:pi/90.:0.5*pi;
ang0_90 = 0.0:pi/2.:0.5*pi;
vec = vector3d(0.0,-sin(ang),cos(ang));
diag = vector3d(0.7071*sin(ang),0.7071*sin(ang),cos(ang));

figure('position',[0 0 500 400])
hold on
plot(ang,YoungsModulus(C_v,vec),'-b','LineWidth',2)
plot(ang,YoungsModulus(C_r,vec),'-b','LineWidth',2)
plot(ang,YoungsModulus(C,diag),'--r','LineWidth',2)
plot(ang,E_v*abs(vec),'-.k','LineWidth',2)
plot(ang,E_r*abs(vec),'-.k','LineWidth',2)

plot(ang,200,'.k','LineWidth',2)
plot(0,158,'s','MarkerSize',10,'MarkerFaceColor','b','MarkerEdgeColor','k')
plot(pi/2.,237,'s','MarkerSize',10,'MarkerFaceColor','b','MarkerEdgeColor','k')
set(gca,'Ylim',[120 300])
set(gca,'XTick',0.0:pi/12.:pi/2.)
set(gca,'XTickLabel',{'B','15�','30�','45�','60�','75�','T'})
hold off
%saveFigure('BT.pdf')

%%

plot(C,'PlotType','velocity','vp','density',1,'complete')

hold on
plot(C,'PlotType','velocity','pp','density',1,'complete')
hold off


%%

b = Miller(0,-1,1,cs,'uvw');  % slip direction
n = Miller(1,1,1,cs,'hkl');   % slip plane normal

 SchmidTensor(n,b)
