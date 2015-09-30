%%             TEXMAT-CZM Texture School, Clausthal, 2015
%
%%                 ODF Modelling with MTEX
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

% determine the maximum value and the modal orientation of an ODF
[value,ori] = max(odf,2)

plot(odf,'sigma','sections',12)

annotate(ori(1),'label','A','backgroundColor','w')
annotate(ori(2),'label','B','backgroundColor','w')

%%

100 * volume(odf,ori(1),10*degree)
100 * volume(odf,ori(2),10*degree)

%%

odf_model = 0.3 * unimodalODF(ori(1),'halfwidth',8.5*degree)  + ...
  0.15 * unimodalODF(ori(2),'halfwidth',10*degree)
plot(odf - odf_model,'sigma','sections',12)
mtexColorMap blue2red
mtexColorbar

%%
% maybe there is some fibre portion

v = vector3d('polar',35*degree,45*degree);
annotate(v)

100 * fibreVolume(odf,Miller(0,0,1,CS),v,10*degree)

figure(2)
plotFibre(odf-odf_model,Miller(0,0,1,CS),v)



%%

unimodal_component2 = unimodalODF(ori(2))

figure(3)
model_odf = 0.5 * unimodal_component + 0.15*unimodal_component2;
plot(model_odf,'sigma','sections',12)


%%

figure(1)
h = Miller(0,0,1,CS)
plotPDF(odf - model_odf,Miller(0,0,1,CS))
mtexColorMap blue2red
colorbar(gcm)

%%

figure(2)
r = vector3d('polar',35*degree,42*degree)
h = Miller(0,0,1,CS)
fibre_component = fibreODF(h,r,'halfwidth',10*degree)

plot(fibre_component,'sections',12,'sigma')

%%

figure(2)
model_odf = 0.4 * unimodal_component + ...
  0.15 * unimodal_component2 + ...
  0.25 * fibre_component;

plot(model_odf,'sigma','sections',12)

figure(1)
plot(odf,'sigma','sections',12)

%% other posible components
%
% uniform components, Bingham distributed components, FourierComponent


%% Ghosts ....................

% some sample ODF
odf = SantaFe

% plot it
plot(odf)

%%
% simulate some pole figure data

% crystal directions
h = [Miller(1,0,0,odf.CS),Miller(1,1,0,odf.CS),Miller(1,1,1,odf.CS)];

% compute pole figures
pf = calcPoleFigure(odf,h);

plot(pf)

%%

odf_rec1 = calcODF(pf)
odf_rec2 = calcODF(pf,'noGhostCorrection')

%%

figure(1)
plotPDF(odf_rec1,h)

figure(2)
plotPDF(odf_rec2,h)

figure(3)
plotPDF(odf,h)

%%

figure(1)
plotODF(odf_rec1,'contourf')
mtexColorMap white2black

figure(2)
plotODF(odf_rec2,'contourf')
mtexColorMap white2black

%% Ghosts in Fourier space

close all;
plotFourier(odf,'linewidth',2)

% keep plotting windows and add next plots
hold all

% without ghost correction:
plotFourier(odf_rec2,'linewidth',2)

% with ghost correction
plotFourier(odf_rec1,'linewidth',2)

legend({'true ODF','without ghost correction','with ghost correction'})
% next plot command overwrites plot window
hold off

%% Options of calcODF
%
% * halfwidth  - of the kernel used for reconstruction
% * resolution - how dense the kernels are placed
% * zero_range - useful for sharp textures
%
%% Exercise
%
% Play around with data correction and reconstruction options to get better
% RP values compare to the default values for the dubna example!
%
%%
