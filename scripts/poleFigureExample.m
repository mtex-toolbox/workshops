%%             TEXMAT-CZM Texture School, Clausthal, 2015
%
%%             Pole Figure Analysis with MTEX
%                Ralf Hielscher, TU Chemnitz
%
%%
% The following script demostrates some of the facilities of MTEX to
% import, correct and analyze pole figure data.
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
close all
%% import data

% load the crystal information file 
CS = loadCIF('quartz.cif')

% the file name containing neutron diffraction intensities
fname = {...
  fullfile(mtexDataPath,'PoleFigure','dubna','Q(02-21)_amp.cnv'),...
  fullfile(mtexDataPath,'PoleFigure','dubna','Q(10-10)_amp.cnv'),...
  fullfile(mtexDataPath,'PoleFigure','dubna','Q(10-11)(01-11)_amp.cnv'),...
  fullfile(mtexDataPath,'PoleFigure','dubna','Q(10-12)_amp.cnv'),...
  fullfile(mtexDataPath,'PoleFigure','dubna','Q(11-20)_amp.cnv'),...
  fullfile(mtexDataPath,'PoleFigure','dubna','Q(11-21)_amp.cnv'),...
  fullfile(mtexDataPath,'PoleFigure','dubna','Q(11-22)_amp.cnv')};

% the measured lattice planes
h = {...
  Miller(0,2,-2,1,CS),...
  Miller(1,0,-1,0,CS),...
  Miller({0,1,-1,1},{1,0,-1,1},CS),... % superposed pole figures
  Miller(1,0,-1,2,CS),...
  Miller(1,1,-2,0,CS),...
  Miller(1,1,-2,1,CS),...
  Miller(1,1,-2,2,CS)};

% the structure coefficients
c = {1,1,[0.52 ,1.23],1,1,1,1};

% import the data
pf = loadPoleFigure(fname,h,'superposition',c)

%% visualize the data

plot(pf)
% plot(pf,'contourf')

mtexColorbar


%% extract pole figure data

% logarithmic plot
logIntensities = log(pf.intensities)/log(10);
plot(pf,logIntensities)
mtexColorbar


%%

pf.CS

pf('11-21','110')

pf('11-21').h

%% modify and correct pole figure data

%% rotate
rot = rotation('axis',vector3d(1,-1,0),'angle',30*degree)
plot(rotate(pf,rot))
mtexColorbar

%% defocussing and background correction 
% Lets define a very simple formula for defocussing correction. In order to
% do defocussing correction right this curve should have been measured from
% a powder sample of the same material.

close all
theta = linspace(0,90*degree)
plot(theta./degree,cos(0.7 * theta),'linewidth',2)
xlabel('polar angle (degree)')
ylabel('I_0 / I_\theta')

%%
% Next we want to use this simple model to correct our pole figure
% intensities.

% copy data into a second variable
pf_cor = pf;

% change intensities in dependency of the polar angle (in MTEX always
% called theta)
pf_cor.intensities = pf.intensities ./ cos(0.7 * pf.r.theta); 

figure(1)
plot(pf_cor)
figure(2)
plot(pf)

%% remove data, e.g. outlier

pf(pf.r.theta<=75*degree & pf.r.theta>=70*degree) = []

%pf(pf.isOutlier)= []

close all
plot(pf)

%% ODF reconstrution
%
% ODF reconstruction in MTEX mean automatic fitting of ODF which consists
% of many unimodal components to the given pole figure intensities. The
% number and halfwidth of those components can be controlled by the options
% |halfwidth| and |resolution|. Lets compare the following two
% reconstructions



odf = calcODF(pf,'zero_Range')
odf_10 = calcODF(pf,'zero_Range','halfwidth',10*degree)

%% plot reconstructed pole figures

figure(1)
plotPDF(odf,pf.h,'superposition',pf.c)

figure(2)
plotPDF(odf_10,pf.h,'superposition',pf.c)

%%
% We observe that choosing a larger halfwidth makes the ODF smoother and in
% general also reduces the fit to the data.

calcError(pf,odf) * 100
calcError(pf,odf_10) * 100


%%
% Contrary, it might help to reduce the halfwidth in order to improve the
% reconstruction for very sharp textures. By default the halfwidth is
% choosen in dependency of the pole figure grid, i.e., a fine grid results
% in a small halfwidth and a coarse grid results in a large halfwidth. 

%%
% We may plot a difference plot between the original pole figures and the
% recalculated pole figures.

pf = loadPoleFigure(fname,h,'superposition',c);
pf_err = calcErrorPF(pf,odf)
plot(pf_err)
mtexColorbar

%%
% Those difference pole figures may be used to filter out outliers from the
% measured diffraction intensities. The filtered diffraction intensities
% may allow for a more accurate reconstruction.

pf(pf_err.intensities>0.7) = []

plot(pf)

odf = calcODF(pf,'zero_range')


%%
% Once an ODF has been reconstructed it can be analyzed in many ways. Lets
% finish this the script by simply plotting the ODF as sigma sections,
% marking it prefered orientation

plot(odf,'sigma','sections',12,'minmax')

[maxValue,maxOri] = max(odf)

annotate(maxOri,'label',char(maxOri),'backgroundcolor','w','interpreter','none')
drawNow(gcm)

%%
% and plotting the c-axis pole figure

plotPDF(odf,Miller(0,0,0,1,CS))
