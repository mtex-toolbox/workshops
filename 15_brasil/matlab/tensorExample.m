%%                MTEX Workshop Belo Horizonte, 2015
%
%%             Tensor Analysis with MTEX
%                Ralf Hielscher, TU Chemnitz
%
%%
% The following script demostrates some of the facilities of MTEX to
% work with tensorial properties.
%
% Run this script section by section and follow the output. You are
% encauraged to alter the script to get a better feeling about MTEX.
%
% important shortcuts:
% Strg + Return         - run the current section
% Shift + Strg + Return - run the current section and go to the next one
% F9                    - evaluate the selected command
%

%%

% adjust plotting convention
plotx2east

%% define crystal symmetry
%
% crystal symmetry - FCC Nickel - slip system {111}<110>
cs = crystalSymmetry('cubic',[3.523,3.523,3.523],'mineral','Nickel')
%
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


%% Real situation in an EBSD map
% So far we have always assumed that the stress tensor is already given
% relatively to the crystal coordinate system. Next we want to examine
% the case where the stress is given in specimen coordinates and 
% we know the orientation of the crystal. 
% Lets assume we have normal stress tensor in 001 direction 
M = zeros(3);M(3,3) = 1;
sigma001 = tensor(M,'name','stress')
%
% Furthermore, we assume the orientations to be given by an EBSD map.
% Thus the next step is to extract the orientations from the EBSD data 
% and transform the stress tensor from specimen to crystal coordinates
%
% load MTEX dataset aachen
mtexdata aachen

% extract the orientations
ori = ebsd('Fe').orientations;

% transform the stress tensor from specimen to crystal coordinates
sigmaCS = rotate(sigma001,inv(ori))

% Next we compute maximum Schmid factor and the active slip system
% for every orientation in the ebsd data set
[Schmid_Max,bActive,nActive,tau,ind] = calcShearStress(sigmaCS,n,b,'symmetrise');

% plot 
plot(ebsd('Fe'),Schmid_Max)
%colorbar(gcm)
%%
% The above procedure may also be applied to grains which has the advantage
% to be much less computational demanding for large data sets.
%
% compute grains
grains = smooth(calcGrains(ebsd('indexed')))
grains_Fe = grains('Fe');

% transform the stress tensor from specimen to crystal coordinates
sigmaCS = rotate(sigma001,inv(grains_Fe.meanOrientation))

% compute maximum Schmid factor and active slip system
[Schmid_Max,bActive,nActive,tau,ind] = calcShearStress(sigmaCS,n,b,'symmetrise');

plot(grains_Fe,abs(Schmid_Max))
%colorbar(gcm)

%% We may also colorize the active slip system.

close all

colorOrder = get(gca,'colorOrder');

% consider only present slips systems
presentSystems = unique(ind);

% cycle through slip systems and plot them
for i = 1:length(presentSystems)
  
  id = presentSystems(i);
  plot( grains_Fe(ind==id) , 'FaceColor', colorOrder(i,:),...
    'DisplayName',[char(nSym(id)) ' ' char(bSym(id))]);  
  hold all
  
end

plot(grains.boundary)
hold off

legend('show')
drawNow(gcm,'figSize','huge')
