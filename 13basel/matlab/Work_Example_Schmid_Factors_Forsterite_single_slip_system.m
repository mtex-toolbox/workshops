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
% David Mainprice (9/10/2003)
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
% extract normal stress direction for printing
v(1) = get(r,'x')
v(2) = get(r,'y')
v(3) = get(r,'z')
% extract hkl and uvw values for printing
n_hkl = get(n,'hkl')
n_uvw = get(b,'uvw')
%
fprintf('  \n')
fprintf('  \n')
fprintf(' %s %3.0f %3.0f %3.0f  \n',' Stress direction (Cartesian specimen coordinates) :',v(:))
fprintf('  \n')
fprintf('              Slip systems \n')
fprintf('  \n')
fprintf('  #    SF      (hkl)          [uvw]  \n')
ii=1;
fprintf(' %2i %s %4.2f %3.0f %3.0f %3.0f %s %3.0f %3.0f %3.0f  \n',ii,' ',SF,n_hkl(:),'  ',n_uvw(:))

%% Schmid factor plot for a single crystal in standard orientation X to north

% r = normal stress directions over upper hemisphere
r = S2Grid('plot','resolution',5*degree,'north')

% Schmid factor for slip direction (b) with slip plane normal (n) for all r
SF = dot(b,r) .* dot(n,r);

% plot 
plot(r,SF,'contourf')
colorbar

%hold on
% N.B. Using LaTex tack symbol \bot and subscript _{c}
%plot([xvector,yvector,zvector,vector3d(1,1,0)],...
%'label',{'b=[100]','n=\bot(010)','[001]','[110]_{c}'},'backgroundcolor','w','FontSize',16)
annotate([xvector,yvector,zvector,vector3d(1,1,0)],...
'label',{'b=[100]','n=\bot(010)','[001]','[110]_{c}'},'backgroundcolor','w','FontSize',16)
%hold off
% save file name  plus .pdf, .eps. , .png



