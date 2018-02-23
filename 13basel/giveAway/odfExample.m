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

% ebsd_bad = loadEBSD('example1.ctf')
% ebsd2 = loadEBSD('example1.ctf','convertSpatial2EulerReferenceFrame');

%% restrict to Forsterite

ebsd = ebsd('Forsterite')
cs = get(ebsd,'CS')

%% plot c-axis distribution

plotpdf(ebsd,Miller(0,0,1,cs))

%% plot as contour plot

plotpdf(ebsd,Miller(0,0,1,cs),'contourf','all')

%% do the same for a inverse pole figure


%% plot measurements in orientation space

plotodf(ebsd)
%plotodf(ebsd,'contourf','all')

%% compute an ODF from the EBSD data

odf = calcODF(ebsd)

%% and plot it in the traditional way

plotodf(odf)

%% or as sigma sections

plotodf(odf,'sigma')

%% plot pole figures of the odf

plotpdf(odf,[Miller(1,0,0,cs),Miller(0,1,0,cs),Miller(0,0,1,cs)])

%% what is the volume of the fibre

r = S2Grid('equispaced');
p = pdf(odf,Miller(0,1,0,cs),r);
[m,id] = max(p);
rMax = r(id)

fibreVolume(odf,Miller(0,1,0,cs),rMax,10*degree) * 100
%fibreVolume(odf,Miller(0,1,0,cs),rMean,10*degree) * 100

%% do the same with the EBSD data

r = ebsd * Miller(0,1,0,cs);
rMean = mean(r,'antipodal')

mean(angle(r,rMean)<10*degree)*100

