%%  Workshop: TEXTURE ANALYSIS AND ORIENTATION IMAGING
%                     Basel, 2013
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


%% Schmid factors for a single crystal in uniaxial compression
%
% Schmid_factor_individual_orientations.m
%
% Using Schmid factor tensor
% by convention 
% b = slip direction [uvw] in the slip plane (hkl) 
% n = slip plane normal(hkl)
% angle b to n = 90 degrees and b.n = 0
%
% Example of Forsterite with stress direction [110]c
% c = Cartesian specimen co-ordinates
% and slip system (010)[100]
%
%% Schmid factor for a single crystal in standard orientation X=North Z=Up
% Cartesian specimen coordinates (X,Y,Z) related crystal co-ordinates
% (a,b,c) with X||a, Y||b and Z||c
%
% single stress directions
%
% Crystal symmetry
CS = symmetry('mmm', [4.756 10.207 5.98], 'mineral', 'Forsterite')

%

%% define the slip directions and slip plane normals

% (010)[100]
% slip direction [100]
b = Miller(1,0,0,CS,'uvw')
% slip plane normal (010)
n = Miller(0,1,0,CS,'hkl') 
%
% b = [100] n = (010)
% check normality
Angle_n_to_b = angle(n,b)/degree

%% define normal stress compression direction in specimen co-ordinates 

r = vector3d(1,1,0)

% Schmid factor
SF = dot(n,r) * dot(b,r)


%% Schmid factor plot for a single crystal in standard orientation X to north

% r = normal stress directions over upper hemisphere
r = S2Grid('plot','resolution',5*degree,'north')

% Schmid factor for slip direction (b) with slip plane normal (n) for all r
SF = dot(b,r) .* dot(n,r);

% plot 
plot(r,SF,'contourf')
colorbar

%hold on
%plot([xvector,yvector,zvector,vector3d(1,1,0)],...
%'label',{'b=[100]','n=\bot(010)','[001]','[110]_{c}'},'backgroundcolor','w','FontSize',16)
%hold off

savefigure('../tensor/pic/SF.pdf')

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
% load ebsd data
ebsd = loadEBSD('Forsterite.ctf','convertEuler2SpatialReferenceFrame')

%%
% extract the orientations
ori = get(ebsd('Fo'),'orientations');

% transform the stress tensor from specimen to crystal coordinates
sigmaCS = rotate(sigma001,inverse(ori))

% Next we compute maximum Schmid factor and the active slip system
% for every orientation in the ebsd data set
[Schmid_Max,bActive,nActive,tau,ind] = calcShearStress(sigmaCS,n,b,'symmetrise');

% plot 
plot(ebsd('Fo'),'property',Schmid_Max)
colorbar

%%
% The above procedure may also be applied to grains which has the advantage
% to be much less computational demanding for large data sets.
%
% compute grains
grains = calcGrains(ebsd)

% extract the orientations
ori = get(grains('Fo'),'orientation');

% transform the stress tensor from specimen to crystal coordinates
sigmaCS = rotate(sigma001,inverse(ori))

% compute maximum Schmid factor and active slip system
[Schmid_Max,bActive,nActive,tau,ind] = calcShearStress(sigmaCS,n,b,'symmetrise');

plot(grains('Fo'),'property',Schmid_Max)
colorbar

%%

savefigure('../tensor/pic/SFEBSD.pdf')

SchmidTensor(n,b)