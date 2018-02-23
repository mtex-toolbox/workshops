%%  Workshop: TEXTURE ANALYSIS AND ORIENTATION IMAGING
%                     Basel, 2013
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

ebsd = loadEBSD('example1.ctf','convertEuler2SpatialReferenceFrame')

grains = calcGrains(ebsd)

%% compute boundary misorientation between two adjacent grains

mori = calcMisorientation(grains(2951),grains(2224))


%% plot the boundary angle distribution

plotAngleDistribution(grains({'Fo','En'}))


%% 

hold on
plotAngleDistribution(grains({'Fo','En'}),'ODF')
hold off

%% compare to the uncorelated angle distribution of the uniform ODF

figure(2)
[v,omega] = angleDistribution(get(grains('Fo'),'CS'));
plot(omega./degree,v)

%% compare to the uncorelated angle distribution of the EBSD data

plotAngleDistribution(grains({'Fo','En'}),'uncorrelated')

