%                   Chemnitz MTEX Workshop, 2016
%
%%                   Tensor Analysis with MTEX
%                    Ralf Hielscher, TU Chemnitz
%
%%
% The following script demostrates how to compute average tensors from
% diffraction pole figures.
%
% Run this script section by section and follow the output. You are
% encauraged to alter the script to get a better feeling about MTEX.
%
% important shortcuts:
% Strg + Return         - run the current section
% Shift + Strg + Return - run the current section and go to the next one
% F9                    - evaluate the selected command
%

%% Basic Setting

% set up a nice colormap
setMTEXpref('defaultColorMap',blue2redColorMap);

% some EBSD data Glaucophane and Epidote
ebsd = loadEBSD([mtexDataPath '/EBSD/data.ctf'],...
  'convertEuler2SpatialReferenceFrame')

%% Define Elastic Stiffness Tensors for Glaucophane and Epidote
%
% Glaucophane elastic stiffness (Cij) Tensor in GPa Bezacier, L., Reynard,
% B., Bass, J.D., Wang, J., and Mainprice, D. (2010) Elasticity of
% glaucophane and seismic properties of high-pressure low-temperature
% oceanic rocks in subduction zones. Tectonophysics, 494, 201-210.

% define the reference frame
csGlaucophane = crystalSymmetry('2/m',[9.5334,17.7347,5.3008],...
  [90.00,103.597,90.00]*degree,'X||a*','Z||c','mineral','Glaucophane');

% define the tensor
CGlaucophane = tensor(...
  [[122.28   45.69   37.24   0.00   2.35   0.00];...
  [  45.69  231.50   74.91   0.00  -4.78   0.00];...
  [  37.24   74.91  254.57   0.00 -23.74   0.00];...
  [   0.00    0.00    0.00  79.67   0.00   8.89];...
  [   2.35   -4.78  -23.74   0.00  52.82   0.00];...
  [   0.00    0.00    0.00   8.89   0.00  51.24]],...
  csGlaucophane,'name','stiffness')

%%
% Epidote elastic stiffness (Cij) Tensor in GPa Aleksandrov, K.S.,
% Alchikov, U.V., Belikov, B.P., Zaslavskii, B.I. and Krupnyi, A.I.: 1974
% 'Velocities of elastic waves in minerals at atmospheric pressure and
% increasing precision of elastic constants by means of EVM (in Russian)',
% Izv. Acad. Sci. USSR, Geol. Ser.10, 15-24.

% define the reference frame
csEpidote= crystalSymmetry('2/m',[8.8877,5.6275,10.1517],...
  [90.00,115.383,90.00]*degree,'X||a*','Z||c','mineral','Epidote');

% define the tensor
CEpidote = tensor(...
  [[211.50    65.60    43.20     0.00     -6.50     0.00];...
  [  65.60   239.00    43.60     0.00    -10.40     0.00];...
  [  43.20    43.60   202.10     0.00    -20.00     0.00];...
  [   0.00     0.00     0.00    39.10      0.00    -2.30];...
  [  -6.50   -10.40   -20.00     0.00     43.40     0.00];...
  [   0.00     0.00     0.00    -2.30      0.00    79.50]],...
  csEpidote,'name','stiffness')

% plot the stiffness tensor
plot(CEpidote,'complete')

%% The Average Tensor from EBSD Data
% The Voigt, Reuss, and Hill averages for all phases are computed by

[CVoigt,CReuss,CHill] =  calcTensor(ebsd({'Epidote','Glaucophane'}),CGlaucophane,CEpidote)

%%
% for a single phase the syntax is

[CVoigtEpidote,CReussEpidote,CHillEpidote] = calcTensor(ebsd('Epidote'),CEpidote)

plot(CVoigtEpidote)


%% ODF Estimation
% Lets assume we do not have individual orientations from EBSD measurements
% but an Epidote ODF obtained from pole figure diffraction measurement.
% Here we simulate this setting by computing an ODF out of the individual
% orientations.

odfEpidote = calcODF(ebsd('Epidote').orientations,'halfwidth',10*degree)


%%
% Now we have two options to compute Voigt, Reuss, Hill average stiffness
% tensors from the Epidote ODF. The easiest way is to compute individual
% orientations from the Epidote ODF and use these individual orientations
% for the average computation

ori = calcOrientations(odfEpidote,10000)

CVoigtE1 = calcTensor(ori,CEpidote)

plot(CVoigtE1)

%%
% We see there is a slight difference compared to the direct computation
% from the EBSD data.
%
% Second, it is possible to compute the average tensors using the harmonic
% expansion of the ODF.

CVoigtE2 = calcTensor(odfEpidote,CEpidote)

plot(CVoigtE2)

%%
% The difference to first way is usually small. The difference to average
% tensor computed directly from the EBSD data can be expained by the
% additional halfwidth parameter which has been used for ODF estimation.

%% Exercises
%
% a) Investigate the influence of the halfwidth to the average tensor
%
% b) Investigate the influence of the number of individual orientations to
% the average tensor