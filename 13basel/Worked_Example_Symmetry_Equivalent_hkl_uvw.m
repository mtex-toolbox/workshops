%
% Worked example crystallographic symmetrically equivalents
% planes (hkl) and directions (uvw)
%
% MTEX 3.4.2
%
% David Mainprice 19/10/2013
%
%%
CS = symmetry('mmm', [4.756 10.207 5.98],'mineral', 'Forsterite');
% plane (101)
m = Miller(1,0,1,CS,'Forsterite','hkl');
% plot
plot(m,'labeled')
% save file
%savefigure('/MatLab_Programs/Forsterite_plane_101.png')
%% Symmetary equvalent planes to (101)
m_equivalent = symmetrise(m);
% plot
plot(m_equivalent,'labeled')
% save file
%savefigure('/MatLab_Programs/Forsterite_planes_101.png')
