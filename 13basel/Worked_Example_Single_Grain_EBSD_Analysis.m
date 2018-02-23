%% Example of general EBSD analysis 
%
% General example of importing EBSD data from 
% HKL/Oxford Channel5 *.ctf export file, correcting Map frame, 
% calculating area fractions, calculating ODF, pole figure plots,
% grain modelling, grain selection, grain boundaries, special boundaries,
% misorientations angles and axes plots.
%
% David Mainprice 18/10/2013
%
% Tip : type 'close all' in the command window to close all open plots
%
%% clear workspace - ensures all variables are NOT old values from previous analysis
clear all
%***********************************************************************
%% Specify Crystal and Specimen Symmetries
%***********************************************************************
% crystal symmetry
CS = {...
    'notIndexed',...
    symmetry('mmm', [4.756 10.207 5.98], 'mineral', 'Forsterite','color', 'dark green'),...
    symmetry('mmm', [18.2406 8.8302 5.1852], 'mineral', 'Enstatite  Opx AV77', 'color', 'light red'),...
    symmetry('2/m', [9.746 8.99 5.251], [90,105.63,90]*degree, 'X||a*', 'Y||b*', 'Z||c',...
    'mineral', 'Diopside   CaMgSi2O6', 'color', 'dark blue')};
% N.B. Default mineral colours are 'light blue','light green','light red','cyan',
% 'magenta','yellow','blue','green','red','dark blue','dark green','dark red'
% You can change the colours to your liking in the listed produced by the EBSD Import Wizard
% Or edit them at mtext-3.4.2/mtex_settings.m
%%
% specimen symmetry
SS = symmetry('-1');

% functions operates in MTEX 3.4.2
setMTEXpref('xAxisDirection','north')
setMTEXpref('zAxisDirection','outOfPlane')
%% plotting convention
plotx2east
%
% N.B. The orientation of the X-axis specimen for EBSD data
%      is SEM dependent its typically X to the East or X to the North,
%      BUT other orientations exist.
%
%      In general you chose to have the plot X-axis specimen in the same
%      orientation as your SEM, but you can chose any other orientation
%      which, may better display the microstructure of your specimen
%      for example your foliation or lamiation East-West or North-South 
%
%***********************************************************************
%% Specify File Names
% path to files
pname = 'giveAway/';
% which files to be imported
fname = {[pname 'Forsterite.ctf']};
%***********************************************************************
%% STEP 1 : Import the Data
%***********************************************************************
% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,SS,'interface','ctf')
%%
%***********************************************************************
% Area fractions of all phases in the ORIGINAL EBSD map
%***********************************************************************
% get phase names
Phase_names = get(ebsd,'minerals');
Area_Fractions = zeros(numel(Phase_names));
% number of grid points in the map
Map_points = length(ebsd);
% print results to screen
fprintf(' \n')
fprintf(' Area fractions for all phases in the EBSD object \n')
fprintf(' N.B. Includes NON-indexed points \n')
fprintf(' \n')
fprintf('   #      Phase       Points  Area fraction \n')
for i=1:numel(Phase_names);
% indexed point for mineral
N_Points = length(ebsd(Phase_names(i)));
% area fraction for mineral
Area_Fractions(i) = N_Points/Map_points;
% retain first part of mineral name
P_Name = strtok(char(Phase_names{i}),' ');
      fprintf(' %3i %12s %10i %11.4f \n',...
      i,P_Name,N_Points,Area_Fractions(i))
end
AF_total = sum(sum(Area_Fractions));
fprintf(' \n')
fprintf(' Total area fraction of whole map = %8.4f \n',AF_total)
fprintf(' \n')
%
% total number of indexed points in map
Indexed_map_points = sum(length(ebsd(Phase_names(2:numel(Phase_names)))));
% percentage of indexed point in map
Percent_indexed = 100*Indexed_map_points/Map_points;
fprintf(' \n')
fprintf(' Percentage indexed points in map = %5.1f \n',Percent_indexed)
fprintf(' \n')
%
% print results to screen
fprintf(' \n')
fprintf(' Area fractions for INDEXED phases in the EBSD object \n')
fprintf(' \n')
fprintf('   #      Phase       Points  Area fraction \n')
for i=2:numel(Phase_names);
% indexed point for mineral
N_Points = length(ebsd(Phase_names(i)));
% area fraction for mineral
Area_Fractions(i) = N_Points/Indexed_map_points;
% retain first part of mineral name
P_Name = strtok(char(Phase_names{i}),' ');
      fprintf(' %3i %12s %10i %11.4f \n',...
      i,P_Name,N_Points,Area_Fractions(i))
end
% total fraction area of index points
AF_total = sum((Area_Fractions(2:numel(Phase_names))));
%
fprintf(' \n')
fprintf(' Total area fraction of INDEXED map points = %8.4f \n',AF_total)
fprintf(' \n')

%***********************************************************************
%% Correct HKL/Oxford Channel5 2D EBSD map frame
%***********************************************************************
% (+X,+Y,-Z) used by HKL/Oxford for plotting EBSD maps
%
% -Z---------> +X
%  |
%  |
%  |
%  |
%  V
% +Y
% to the traditional mathematical axes (+X and +Y), which are compatiable
% with MTEX. N.B. this is separate issue to the choice of plotting 
% convention with plotx2east, plotx2north etc.
%
% +Y
%  |
%  |
%  |
%  |
% +Z---------> +X
%  
% by a rotation of about +X specimen axis of 180 degrees
% rotate the EBSD map frame, BUT keep the original Euler angles
ebsd = rotate(ebsd,rotation('axis',xvector,'angle',180*degree),'keepEuler');
%***********************************************************************
%% Fix the map aspect ratio and dimensions
%***********************************************************************
ratio = (max(get(ebsd,'x')) - min(get(ebsd,'x')))...
       /(max(get(ebsd,'y')) - min(get(ebsd,'y')));
% plot height (you can change this value)
plot_h = 600;
% plot width with correct aspect ratio
plot_w = round(600*ratio);
%***********************************************************************
%% Visualize the map data
%***********************************************************************
% use figure keeps plot open and sets dimensions of plot
figure('position',[200 200 plot_w plot_h])
plot(ebsd,'property','phase')
%% Orientation map
figure('position',[200 200 plot_w plot_h])
plot(ebsd,'colorcoding','ipdfHKL','antipodal')
%% Quality Map - Mean Angular Deviation = mad
figure('position',[200 200 plot_w plot_h])
plot(ebsd,'property','mad')
colorbar
%% Standard gray map 8-bit Band Contrast (BC) Map
% non-index is black and grain internal microstructure more visible
% 255 levels RGB=000 (black) to RGB=111 (white)
figure('position',[200 200 plot_w plot_h])
std_gray = makeColorMap([0 0 0],[0.5 0.5 0.5],[1 1 1],255);
plot(ebsd,'property','bc');
colormap(std_gray)
colorbar
%% Alternative gray map 8-bit Band Contrast (BC) Map
% non-index is white and grain internal microstructure less visible
figure('position',[200 200 plot_w plot_h])
std_gray2 = makeColorMap([1 1 1],[0.5 0.5 0.5],[0 0 0],255);
plot(ebsd,'property','mad')
colormap(std_gray2)
colorbar
%***********************************************************************
%% STEP 2 : You must create an ODF for contour plots
%***********************************************************************
%  to calcluated Texture Index, to plot contoured ODF, Pole Figures,
% Inverse Pole figures ...
% Calculate an ODF for the mineral Olivine
% Here we define the half-width of radial bell-shaped kernel function
% The de vallee Poussin is the default kernel function for texture analyisis 
odf_olivine = calcODF(ebsd('Forsterite'),'halfwidth',10*degree)
%***********************************************************************
%% Calculate Texture index
%***********************************************************************
% MTEX use 'Texture Index', Bunge(1982) uses 'J-index' and Matthies et
% al.(1997) uses 'F2' as this a function of f(g)^2, f(g)=ODF
% J-index = integral of f(g)^2 dg   dg=(dphi1 dPHI dphi2 sinPHI)/8pi^2
%  texture index of the ODF
TI_odf = textureindex(odf_olivine)
%***********************************************************************
%% Plot the ODF - default Bunge Euler angle phi2 sections with x=phi1 y=PHI
%***********************************************************************
figure('position',[0   0   700   300])
plotodf(odf_olivine,'sections',18,'resolution',2*degree,'contourf')
%***********************************************************************
%% Plot the ODF - Matthais and Roe Euler (alpha,beta,gamma)angles sigma sections
% section is sigma = alpha + beta
% and the azimuth measured from East is alpha
%***********************************************************************
figure('position',[0   0   700   300])
plotodf(odf_olivine,'sections',18,'resolution',2*degree,'contourf','sigma')
%***********************************************************************
%% STEP3 : create a list of hkls or uvws for your pole figure plots
%***********************************************************************
% MTEX cannot mix pole to planes 'hkl' and directions 'uvw' in one plot
% pole to planes can be specified by the option 'hkl' 
%
% list one : (hkl) (plane normals)
pfs_olivine_hkl = (...
    [Miller(1,0,0,CS,'Forsterite','hkl'),...
    Miller(0,1,0,CS,'Forsterite','hkl'),...
    Miller(0,0,1,CS,'Forsterite','hkl'),...
    Miller(1,1,1,CS,'Forsterite','hkl')])
% list two : [uvw] [directions]
pfs_olivine_uvw = (...
    [Miller(1,0,0,CS,'Forsterite','uvw'),...
    Miller(0,1,0,CS,'Forsterite','uvw'),...
    Miller(0,0,1,CS,'Forsterite','uvw'),...
    Miller(1,1,1,CS,'Forsterite','uvw')])
%***********************************************************************
%% Scatter plots
%***********************************************************************
figure('position',[0   0   700   300])
plotpdf(ebsd('Forsterite'),pfs_olivine_hkl,'all','antipodal','MarkerSize',4,'MarkerColor','m');
%% Scatter plots
plotpdf(ebsd('Forsterite'),pfs_olivine_hkl,'antipodal','MarkerSize',4,'property','mad');
colorbar
%% Scatter plots
plotpdf(ebsd('Forsterite'),pfs_olivine_hkl,'lower','MarkerSize',4,'MarkerColor','k');
%% Scatter plots
plotpdf(ebsd('Forsterite'),pfs_olivine_hkl,'upper','MarkerSize',4,'MarkerColor','b');
%***********************************************************************
%% STEP4 : plot contoured pole figures
%***********************************************************************
% Options:
%
% 'antipodal', also known as non-polar, the +hkl and -hkl directions
% are rotated into the same hemisphere (default upper),(e.g. 001 and 00-1),
% resulting all data is plotted in one hemisphere. This typically the
% default setting used by most people.
%
% Alternative options
% 'complete' = whole hemisphere, plots 'upper' and 'lower' hemispheres.
% 'north' or 'upper' = plots data in the upper hemisphere.
% 'south' or 'lower' = plots data in the lower hemisphere.
%
% Contouring options:
% 'resolution' - resolution in degrees
% 'contour' - colour contour lines
% 'contourf' - filled color between contours
% 'logarithmic' - log scale
% 'gray' - gray colour scale
%
% figure position vectors - [left bottom width height]
%       I------------I   I 
%       I            I   I
%       I<--width--->I height
%       I            I   I
%       I------------I   I
%--left--      
%       I
%    bottom
%       I
figure('position',[10   10   700   300])
plotpdf(odf_olivine,pfs_olivine_hkl)
% annotate with text labels X,Y,Z at positions in the pole figure
% specimen coordinates are given by vector3d(x,y,z) 
% in this case we can use the predefined vector3d - coordinates xvector,yvector,zvector
% or you can use polar angles (anti-clockwise positive)
polar_angle = 60*degree;
azimuth_angle = 45*degree;
v = vector3d('polar',polar_angle,azimuth_angle);
annotate([xvector,yvector,zvector,v],...
'label',{'X','Y','Z','Vector'},'backgroundcolor','w')
% use colorbar if you all pole figure contoured on the SAME SSCALE
% remove colorbar if whant the pole figures contoured INDIVIDUALLYcolorbar
%***********************************************************************
% save graphics file
%***********************************************************************
% file name  plus .pdf, .eps. , .png
%savefigure('/MatLab_Programs/PFs_olivine.png')
%***********************************************************************
%% pole figures of uvw
%***********************************************************************
figure('position',[0   0   700   300]);
plotpdf(odf_olivine,pfs_olivine_uvw)
annotate([xvector,yvector,zvector],...
'label',{'X','Y','Z'},'backgroundcolor','w')
%***********************************************************************
% save graphics file
%***********************************************************************
% file name  plus .pdf, .eps. , .png
%savefigure('/MatLab_Programs/PFs_olivine.png')
%***********************************************************************
%% note difference between (hkl)=(111) and [uvw]=[111] pole figures
%***********************************************************************
%
% Why ? For which crystal symmetries would (111) and [111] the same ?
%
cs_for = symmetry('mmm', [4.756 10.207 5.98],[90,90,90]*degree,'mineral','Forsterite')
hkl_111 = Miller(1,1,1,cs_for,'Forsterite','hkl')
uvw_111 = Miller(1,1,1,cs_for,'Forsterite','uvw')
angle_hkl_111_uvw_111 = angle(hkl_111,uvw_111)/degree
%%
uvw_100 = Miller(1,0,0,cs_for,'Forsterite','uvw')
uvw_010 = Miller(0,1,0,cs_for,'Forsterite','uvw')
uvw_001 = Miller(0,0,1,cs_for,'Forsterite','uvw')
% plot
hold all
plot([uvw_100,uvw_010,uvw_001,uvw_111],'all','labeled')
plot(hkl_111,'all','labeled')
hold off
%savefigure('/MatLab_Programs/PFs_hkl_uvw_olivine.png')
%**************************************************************************
%% Detect grains using the segmentation angle and keep non-indexed option
%**************************************************************************
%
% You can loop over this cell changing segmentation angle and the
% the 'keepNotIndexed' options
% You should compared the resulting grain map with EBSD (pixel) phase
% or orientation (pixel) map
%**************************************************************************
%
disp(' ')
disp(' Grain segmentation angle option ')
disp(' Choose a high angle typically between 15 to 10 degrees for geological samples')
disp(' OR choose low angle of 2 degrees if you want to detect sub-grains')
segmentation_angle = input('The segmentation angle (e.g. 2-15):');
segAngle = segmentation_angle*degree;
%
disp(' ')
disp(' Keep non-indexed points option ')
disp('*1= Scientifically correct, not extrapolating raw indexed data')
disp('    model grains BUT keep non-index points')
disp(' 2= May be more geologically correct in some cases, use with care')
disp('    model grains AND fill non-index points')
non_indexed_option = input('Option an integer  (1-2):');
%
% keep non-indexed
if(non_indexed_option == 1)
  grains = calcGrains(ebsd,'threshold',segAngle,'keepNotIndexed')
end
% remove non-indexed points
if(non_indexed_option == 2)
  grains = calcGrains(ebsd,'threshold',segAngle)
end 
%
% number of orientation and grains
n_olivine_orientations = length(grains('Forsterite'))
n_olivine_grains = numel(grains('Forsterite'))
%
% plot grain phase map
figure('position',[200 200 plot_w plot_h])
plot(grains,'property','phase')
%
%**************************************************************************
%% Removing small grains - not representative small grains, may be errors
%**************************************************************************
%
% You can loop over this cell changing number of indexed points per grain
% You should compared the resulting grain map with EBSD (pixel) phase
% or orientation (pixel) map
%**************************************************************************
%
disp(' ')
disp(' Small grains option:')
disp(' Remove small grains containing less than a critical')
disp(' number of indexed points as they error prone or')
disp(' if you require an accurate grain size and shape analysis')
disp(' the recommended minimum number indexed points per grain size is 10')
disp(' You can decide to keep all grain by accepting grains with only 0 indexed point')
small_grains_option = input('Indexed points per grain an integer (e.g. 0-10):');
%
% remove grains containing less than critical number of indexed points, 
selected_grains = grains(grainSize(grains)>small_grains_option);
% number of orientation and grains
n_olivine_orientations = length(selected_grains('Forsterite'))
n_olivine_grains = numel(selected_grains('Forsterite'))
%
% plot grain map
figure('position',[200 200 plot_w plot_h])
plot(selected_grains,'property','phase')
%
%% plot all grains and their bary centers
bary_center_xys = centroid(selected_grains)
plot(selected_grains,'property','phase')
hold on
plot(bary_center_xys(:,1),bary_center_xys(:,2),'s','MarkerEdgeColor','k','MarkerFaceColor','r',...
                'MarkerSize',5)
hold off
%% selecting a single grain by x,y coordinates
xg =  1000
yg = -6000
selected_single_grain = findByLocation(grains,[xg  yg])
plotBoundary(selected_single_grain,'linewidth',2)
hold on, plot(selected_single_grain)
% calculates the barycenter of the grain-polygon, with respect to its holes
bary_center_xy = centroid(selected_single_grain)
hold on
plot(bary_center_xy,'s','MarkerEdgeColor','k','MarkerFaceColor','r',...
                'MarkerSize',20)
hold off
%% visualize the misorientation within a grain
% get all misorientations from the mean orientation
o = get(selected_single_grain,'mis2mean')
% plot misorientation angles from the mean
close, plotspatial(selected_single_grain,'property',angle(o)/degree)
colorbar
%%
close, plotspatial(selected_single_grain,'property','mis2mean')
colorbar
%%
% plot a histogram of the misorientation angles
close all
hist(angle(o)/degree)
xlabel('Misorientation angles in degrees')
%% uncorrelated misorientation in the grain
plotAngleDistribution(selected_single_grain,'ODF')
%% correlated misorientation in the grain ?
o_in_grain = get(selected_single_grain,'orientations');
plotAngleDistribution(o_in_grain,'uncorrelated')
% correlated misorientation in the grain ?
%% plotAxisDistribution correlated
plotAxisDistribution(selected_single_grain,'correlated','contourf','antipodal')
annotate([Miller(1,0,0,CS,'Forsterite','uvw'),Miller(0,1,0,CS,'Forsterite','uvw'),Miller(0,0,1,CS,'Forsterite','uvw')],'all','labeled')
colorbar
%% individual orientations of the EBSD data within grains
o_in_grain = get(selected_single_grain,'orientations');
pfs_olivine_hkl = (...
    [Miller(1,0,0,CS,'Forsterite','hkl'),...
    Miller(0,1,0,CS,'Forsterite','hkl'),...
    Miller(0,0,1,CS,'Forsterite','hkl')])
figure('position',[0   0   700   300])
plotpdf(o_in_grain,pfs_olivine_hkl,'all','antipodal','MarkerSize',2,'MarkerColor','b');
%% line profile
close,   plotBoundary(selected_single_grain,'linewidth',2)
o = get(selected_single_grain,'mis2mean')
hold on, plotspatial(selected_single_grain,'property',angle(o)/degree)
%max(get(selected_single_grain,'x'))
% Define profile
Xstart = 0;
Ystart = -5000;
Xend =2850;
Yend = -9000;
XYprofile =  [Xstart Ystart; Xend  Yend];
line(XYprofile(:,1),XYprofile(:,2),'linewidth',2)
%% Plot misorientation profile
% extract orientations along XYprofile
[o_XYprofile,Position] = spatialProfile(selected_single_grain,XYprofile);
% Calcluate misorientation angle along XYprofile and plot results
% Misorientation with respect the first point along profile
m_XYprofile1 = o_XYprofile(1).\o_XYprofile
% Misorientation with respect the neighbouring point along profile
m_XYprofile2 = o_XYprofile(1:end-1).\o_XYprofile(2:end)
% plot
close, plot(Position,angle(m_XYprofile1)/degree,'color','b')
hold on, plot(Position(1:end-1)+diff(Position)./2,... % shift
  angle(m_XYprofile2)/degree,'color','r')
xlabel('Position'); ylabel('Orientation difference in degree')
legend('wrt first orientation','wrt neighbouring orientation')
%% analysis of misorientation profile wrt neighbouring orientation
% minimum misorientation angle
min_angle_degrees = angle(m_XYprofile2)/degree;
% minimum misorientation axis hkil (i.e. corresponding to minimum angle)
min_axis_hkl = axis(m_XYprofile2);
% minimum misorientation axis uvtw
min_axis_uvw = uvw(min_axis_hkl);
% maximum rotation angle in profile
[Max_angle,Index] = max(min_angle_degrees)
% associated rotation axis
Max_axis_uvw = min_axis_uvw(Index,:)
% associated position
Max_Position = Position(Index)
% extract axes for fprintf
axes_uvw = get(min_axis_uvw,'uvw');
%
fprintf('  \n')
fprintf('      Correlated misorientation profile:\n')
fprintf('      misoreintation MINIMUM angles and their rotation axes wrt neighbouring orientation\n')
fprintf('  \n')
fprintf(' %d %s %8.2f %s %8.4f %s %8.4f %8.4f %8.4f \n',i,' * ',Position(i),' * ', min_angle_degrees(i),' * ',axes_uvw(i,:))
fprintf('  \n')
fprintf(' #    Position * angle  * axis [uvw]  \n')
for i=1:numel(min_axis_uvw)
fprintf(' %d %s %8.2f %s %8.4f %s %8.4f %8.4f %8.4f \n',i,' * ',Position(i),' * ', min_angle_degrees(i),' * ',axes_uvw(i,:))
end
%% plot misorientation axes in crystal coordinates
% plot misorientation axes 
plot(symmetrise(min_axis_uvw),'antipodal','MarkerSize',4,'MarkerColor','b','grid')
hold on
% plot misorientation axes associated with maximum misorientation angle as mauve 
plot(symmetrise(Max_axis_uvw),'antipodal','MarkerSize',4,'MarkerColor','m')
hold on
%annotate([Miller(1,0,0,CS,'Forsterite','uvw'),Miller(0,1,0,CS,'Forsterite','uvw'),Miller(0,0,1,CS,'Forsterite','uvw')],'all','labeled')
plot([Miller(1,0,0,CS,'Forsterite','uvw'),Miller(0,1,0,CS,'Forsterite','uvw'),Miller(0,0,1,CS,'Forsterite','uvw')],'all','labeled')
hold off
%**************************************************************************
%% EBSD Maps - grains, grain boundaries and misorientations
%**************************************************************************
%
figure('position',[200 200 plot_w plot_h])
plot(selected_grains,'property','phase')
hold on
plotBoundary(selected_grains,'linecolor','r','linewidth',1)
hold off
% Correct MatLab problem with colour buffer
set(gcf,'renderer','zbuffer')
%**************************************************************************
%% EBSD Maps - band constrast map with grain boundaries and misorientations
%**************************************************************************
% non-index is black and grain internal microstructure more visible
% 255 levels RGB=000 (black) to RGB=111 (white)
figure('position',[200 200 plot_w plot_h])
std_gray = makeColorMap([0 0 0],[0.5 0.5 0.5],[1 1 1],255);
plot(ebsd,'property','bc');
colormap(std_gray)
hold on
plotBoundary(selected_grains,'linecolor','w','linewidth',1)
hold off
% Correct MatLab problem with colour buffer
set(gcf,'renderer','zbuffer')
%**************************************************************************
%% Plot grain boundaries and misorientation from mean grain orientations
%**************************************************************************
figure('position',[200 200 plot_w plot_h])
plotBoundary(selected_grains)
hold on
plot(selected_grains,'property','mis2mean')
hold off
% Correct MatLab problem with colour buffer
set(gcf,'renderer','zbuffer')
%**************************************************************************
%% Plot misorientation angle along a grain boundary
%**************************************************************************
figure('position',[200 200 plot_w plot_h])
plotBoundary(selected_grains,'property','angle','linewidth',1)
colorbar
%**************************************************************************
%% Plot grain boundaries between different phases
%**************************************************************************
figure('position',[200 200 plot_w plot_h])
plotBoundary(selected_grains,'property','phase','linewidth',1)
%**************************************************************************
%% Mark grain and sub-grain boundaries by its misorientation angle range
%**************************************************************************
figure('position',[200 200 plot_w plot_h])
% plot all misorientation boundaries of all angles as black lines
plotBoundary(selected_grains,'linecolor','k','linewidth',1)
hold on
% superpose misorientation boundaries with specific angle ranges
% 20-25 magenta, 15-20 cyan, 10-15 blue,5-10 green,3-5 red
plotBoundary(selected_grains,'property',[20 25]*degree,'linecolor','m','linewidth',2)
plotBoundary(selected_grains,'property',[15 20]*degree,'linecolor','c','linewidth',2)
plotBoundary(selected_grains,'property',[10 15]*degree,'linecolor','b','linewidth',2)
plotBoundary(selected_grains,'property',[ 5 10]*degree,'linecolor','g','linewidth',2)
plotBoundary(selected_grains,'property',[ 3  5]*degree,'linecolor','r','linewidth',2)
% legend
legend('>25^\circ',...
  '20^\circ-25^\circ',...
  '15^\circ-20^\circ',...
  '10^\circ-15^\circ',...
  '5^\circ-10^\circ',...
  '3^\circ-5^\circ')
hold off
% Correct MatLab problem with colour buffer
set(gcf,'renderer','zbuffer')
%% Mark misorientation boundaries with specific crystallographic axis and angle
%**************************************************************************
% define special misorientation relationship in Forsterite
cs_for = symmetry('mmm', [4.756 10.207 5.98],[90,90,90]*degree,'mineral','Forsterite');
% 60 degrees around a-axis, this often causedby indexing error 
% in Forsterite called 'pseudo-symmetry'
a_axis_60deg = rotation('axis',Miller(1,0,0,cs_for,'Forsterite','uvw'),'angle',60*degree)
% plot black grain boundaries
figure('position',[200 200 plot_w plot_h])
% plot all misorientation boundaries of all angles as black lines
plotBoundary(selected_grains,'linecolor','k','linewidth',1)
hold on
% plot misorientation boundaries with a-axis rotation axis/60 degrees within 3 degrees
plotBoundary(selected_grains('Forsterite'),'property',a_axis_60deg,'delta',3*degree,...
  'linecolor','r','linewidth',2)
hold off
% Correct MatLab problem with colour buffer
set(gcf,'renderer','zbuffer')
%% Misorientation angles of neighbouring grains of all phases
% plot them into our orientation plot
figure('position',[200 200 plot_w plot_h])
plot(ebsd,'colorcoding','ipdfHKL')
hold on
plotBoundary(selected_grains,'property','angle','linewidth',3)
colorbar
hold off
% Correct MatLab problem with colour buffer
set(gcf,'renderer','zbuffer')
%% plot internal misorientation from the mean orientation of each grain
plot(selected_grains,'property','mis2mean','colorcoding','angle')
hold on
plotBoundary(selected_grains,'linecolor','k','linewidth',2)
hold off
colorbar
% Correct MatLab problem with colour buffer
set(gcf,'renderer','zbuffer')
%
%**************************************************************************
% Misorientation Angles (for all rotation axes)
%**************************************************************************
%
%% Correlated misorientation grains (all phases)
plotAngleDistribution(selected_grains)
title('All phases : Correlated misorientation grains','FontSize',14)
hold on
% uniform misorientation distribution
plotAngleDistribution(selected_grains,'ODF')
hold off
%% Unorrelated misorientation grains (all phases)
plotAngleDistribution(grains,'uncorrelated')
title('All phases : unorrelated misorientation grains','FontSize',14)
hold on
% uniform misorientation distribution
plotAngleDistribution(selected_grains,'ODF')
hold off
%% Misorientation WITHIN grains (intragranular misorientation)
%
% get the misorientations ANGLES within grains to mean orientation of each grain
% N.B. Commande restricted to a SINGLE phase
intragranular_mis_ol_angles = angle(get(selected_grains('Forsterite'),'mis2mean'))/degree;
intragranular_mis_ol_max = max(intragranular_mis_ol_angles)
intragranular_mis_ol_min = min(intragranular_mis_ol_angles)
intragranular_mis_ol_mean = mean(intragranular_mis_ol_angles)
% mode the most frequently occurring value
intragranular_mis_ol_mode = mode(intragranular_mis_ol_angles)
% plot a histogram of the misorientation angles
nbins=20;
figure
hist(intragranular_mis_ol_angles)
xlabel('Misorientation angles (�)','FontSize',18)
ylabel('Frequency','FontSize',18)
title('Olivine : Intragranular misorientation from mean grain orientation','FontSize',18)
savefigure('/MatLab_Programs/Intragranular_Misorientation_angles.png');
%% Misorientations angles BETWEEN grains (intergranular misorientation)
% get the misorientations angles BETWEEN grains
%
% create a reference uniform MDF
CS_olivine = symmetry('mmm', [4.756 10.207 5.98], 'mineral', 'Forsterite');
mdf_uniform_olivine = calcMDF(uniformODF(CS_olivine,SS),uniformODF(CS_olivine,SS))
%
figure
% Correlated between physically adjacent pixels on a
% grain boundary using GrainSet class (red histogram bars)
plotAngleDistribution(selected_grains('Forsterite'),'FontSize',18)
hold on
% Uncorrelated angle distribution from MDF (line)
plotAngleDistribution(selected_grains('Forsterite'),'MDF','resolution',...
    1*degree,'FontSize',18)
hold on
% Uniform angle distribution (line)
plotAngleDistribution(mdf_uniform_olivine,'resolution',1*degree)
title('Intergranular misorientation: olivine','FontSize',18)
hold off
text(7,25,...
'{Correlated grains (bars) Uncorrelated grains (line) & Uniform MDF (line)}'...
,'FontSize',13)
savefigure('/MatLab_Programs/Misorientation_angles.png');
%
%**************************************************************************
% Misorientation Axes (for all rotation angles)
%**************************************************************************
%
%% Uncorrelated misorientation rotation axes (for all rotation angles)
plotAxisDistribution(selected_grains('Forsterite'),'uncorrelated',...
    'contourf','complete','antipodal','resolution',5*degree)
colorbar
hold on
annotate([Miller(1,0,0),Miller(0,1,0),Miller(0,0,1)],'all','labeled')
hold off
savefigure('/MatLab_Programs/Uncorrelated_Misorientation_axes.png');
%% Correlated misorientation rotation axes (for all rotation angles)
plotAxisDistribution(selected_grains('Forsterite'),...
    'contourf','complete','antipodal','resolution',5*degree)
colorbar
hold on
annotate([Miller(1,0,0),Miller(0,1,0),Miller(0,0,1)],'all','labeled')
hold off
savefigure('/MatLab_Programs/Correlated_Misorientation_axes.png');
%% Uniform misorientation rotation axes (for all rotation angles)
plotAxisDistribution(mdf_uniform_olivine,'complete','antipodal','resolution',5*degree)
colorbar
hold on
annotate([Miller(1,0,0),Miller(0,1,0),Miller(0,0,1)],'all','labeled')
hold off
savefigure('/MatLab_Programs/Uniform_Misorientation_axes.png');
