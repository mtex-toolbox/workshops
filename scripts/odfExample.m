%                Chemnitz MTEX Workshop, 2016
%
%%                 ODF Analysis with MTEX
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

plot(ebsd)

%% restrict to Forsterite

ebsd = ebsd('Forsterite')

%% plot c-axis distribution

plotPDF(ebsd.orientations,Miller(0,0,1,ebsd.CS))
mtexColorMap LaboTeX

%% plot as contour plot

plotPDF(ebsd.orientations,Miller(0,0,1,ebsd.CS),'contourf')
mtexColorMap LaboTeX

%% do the same for a inverse pole figure

plotIPDF(ebsd.orientations,vector3d.X,'contourf')
mtexColorMap LaboTeX

%% plot measurements in orientation space

figure(1)
plotSection(ebsd.orientations,'sections',6)
%plotSection(ebsd.orientations,'sections',6,'contourf','all') % this takes some time
mtexColorMap LaboTeX

%% compute an ODF from the EBSD data

odf = calcODF(ebsd.orientations,'halfwidth',7.5*degree)

%% and plot it in the traditional way

figure(2)
plot(odf,'sections',6,'contourf')
mtexColorMap LaboTeX

%% or as sigma sections

plot(odf,'sigma')
mtexColorMap LaboTeX

%% plot pole figures of the odf

plotPDF(odf,Miller({1,0,0},{0,1,0},{0,0,1},odf.CS))

%%

plotIPDF(odf,xvector,odf.CS)

%%

ori = calcModes(odf,2)

%%

plot(odf,'sections',12)

%%

hold on
plot(ori,'MarkerFaceColor','k','marker','s')
hold off


%% what is the volume of the fibre
% there seems to be a fibre visible in (010) pole figure

% determine the maximum of the pole figure
r = regularS2Grid('resolution',1*degree,'upper');
p = calcPDF(odf,Miller(0,1,0,odf.CS),r);
[m,id] = max(p);
rMax = r(id)

% plot the point to the pole figure plot
% mtexFig = gcm;
% plot(rMax,'parent',mtexFig.children(2),'marker','s','markerEdgeColor','w','MarkerFaceColor','k')

fibreVolume(odf,Miller(0,1,0,odf.CS),rMax,10*degree) * 100

%% do the same with the EBSD data

r = ebsd.orientations * Miller(0,1,0,odf.CS)
rMean = mean(r)

fibreVolume(ebsd.orientations,Miller(0,1,0,odf.CS),rMean,10*degree) * 100

% this is actually only a shortcut for
%mean( angle(r,rMean) < 10*degree ) * 100

% Question: what is wrong with these lines?
% Tip: 
% plot(r,'contourf')
% annotate(rMean)


%%

plotIPDF(odf,rMax)

%%

figure
plotFibre(odf,Miller(0,1,0,odf.CS),rMax)


%% advanced topic -- kernel density estimation
%% --------------------------------------------------


%% Lets start with some EBSD data

plotx2east
mtexdata mylonite

plot(ebsd)

%% lets have a look at the orientations of the quartz phase

ori = ebsd('quartz').orientations

%% how are the c-axes distributed

plot( ori * Miller(0,0,1,'uvw',ori.CS))

%% Oh, we forgott to symmetrise

plot(ori * symmetrise(Miller(0,0,1,'uvw',ori.CS)))

%% not to much to see, maybe this is better

plot(ori * symmetrise(Miller(0,0,1,'uvw',ori.CS)),'contourf','upper')

%% we can do the same in the orientation space

plotSection(ori,'sections',6,'sigma')

%%

plotSection(ori,'contourf','sections',6,'sigma')

%setColorRange('equal')

%% thats nice but how does it works? - a one dimensional analogon
% some random points telling us not to much about the underlying
% distribution

y = randomPoints(40);
close all
plot(y,zeros(size(y)),'o','MarkerSize',10,'MarkerFaceColor','b')

%% maybe we should use a histogram

y = randomPoints(400000);

hist(y,100)

%% not so good, it is not smooth at all,  other idea: kernel density estimators

clf
N = 10;
y = randomPoints(N);
plot(y,zeros(size(y)),'o','MarkerSize',10,'MarkerFaceColor','r')

% some discretisation
x = linspace(0,1,500);

s = 0.2;
z = zeros(1,length(x));
ssz = [];

hold on
for i = 1:length(y)
  psi = Gaussian(x,y(i),s) ./ length(y);
  
  plot(x,psi,'-k','linewidth',2);
  
  z = z + psi;
end

plot(x,z,'-b','linewidth',2)
hold off

%%
% We see that for N to infinity the sum of the kernel functions converges
% to limitting function. In the case of single orientation measurement we
% call this function the orientation distribution function of the specimen

odf = calcODF(ebsd('quartz').orientations)

%%
% with the ODF we have smooth plots for the orientation distribution

plot(odf,'sections',6)

%%
% as well as for the c-axis distribution

plotPDF(odf,Miller(0,0,1,odf.CS))

%%
% Remember that there was a kernel involved in the definition of the ODF.
% Lets make this more explicite

psi = deLaValeePoussinKernel('halfwidth',5*degree)
close all
plot(psi,'K','symmetric')

%%

odf = calcODF(ebsd('quartz').orientations,'kernel',psi)

plot(odf,'sections',6)

%%
% As we do have infinte measurements we can not say which ODF is correct
% or which kernel is correct. At this point the experience of the user is
% required.

%%
% you can do the same with misorientations - but this is a different story
% ...


