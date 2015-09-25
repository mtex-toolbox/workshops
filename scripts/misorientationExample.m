%%               MTEX TUTORIAL, ICOTOM 17
%                     Dresden, 2014
%
%%             EBSD Analysis with MTEX
%                Ralf Hielscher, TU Chemnitz
%
%%
% The following script demostrates some of the facilities of MTEX to
% import, correct and analyze EBSD data.
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

%% import data

fname = fullfile(mtexDataPath,'EBSD','Forsterite.ctf');
ebsd = loadEBSD(fname,'convertEuler2SpatialReferenceFrame')

grains = calcGrains(ebsd)


%% plot the boundary angle distribution for Forsterite - Enstatite phase transition

plotAngleDistribution(grains.boundary('Fo','En').misorientation)
% plotAngleDistribution(grains.boundary)

%% 


odf_Fo = calcFourierODF(ebsd('Fo').orientations)
odf_En = calcFourierODF(ebsd('En').orientations)
modf = calcMDF(odf_Fo,odf_En)

% modf = calcMDF(ebsd('Fo'),ebsd('En'))

hold all
plotAngleDistribution(modf)
hold off

%% compare to the uncorelated angle distribution of the uniform ODF

figure(2)
[v,omega] = angleDistribution(ebsd('Fo').CS);
plot(omega./degree,v)

%% compare to the uncorelated angle distribution of the EBSD data

plotAngleDistribution(calcMisorientation(ebsd('Fo'),ebsd('En')))

%%

mIndex(ebsd('Fo'))
