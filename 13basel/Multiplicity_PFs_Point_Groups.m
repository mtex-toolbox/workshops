%
% By David Mainprice  (last revised 5/10/2013)
% Geosciences Montpellier
% e-mail: David.Mainprice@gm.univ-montp2.fr
%
disp(' ')    
disp(' Script Multiplicity_PFs_Point_Groups.m by David Mainprice')
disp(' FUNCTION: 5/10/2013')
disp(' Calculate a upper and lower hemisphere pole figures')
disp(' for all point groups and Laue classes for single orientation unimodal ODF')
disp(' using MTEX the open source Texture analysis toolbox')
disp(' ')
disp(' further information about this script e-mail: David.Mainprice@gm.univ-montp2.fr')
disp(' ')
disp(' for further information about MTEX see http://code.google.com/p/mtex/')
disp(' ')
%
% Specify Crystal and Specimen Symmetries
%********************************************************
% plotting convention - (x-sample // north)
%********************************************************
plotx2north
%
%********************************************************
% specify crystal point group (CS) symmetries
%********************************************************
% CS Crystal Symmetry MTEX strings
CS_MTEX{1}{1}='1';
CS_MTEX{2}{1}='-1';
CS_MTEX{3}{1}='2';
CS_MTEX{4}{1}='m';
CS_MTEX{5}{1}='2/m';
CS_MTEX{6}{1}='222';
CS_MTEX{7}{1}='mm2';
CS_MTEX{8}{1}='mmm';
CS_MTEX{9}{1}='4';
CS_MTEX{10}{1}='-4';
CS_MTEX{11}{1}='4/m';
CS_MTEX{12}{1}='422';
CS_MTEX{13}{1}='4mm';
CS_MTEX{14}{1}='-42m';
CS_MTEX{15}{1}='4/mmm';
CS_MTEX{16}{1}='3';
CS_MTEX{17}{1}='-3';
CS_MTEX{18}{1}='32';
CS_MTEX{19}{1}='3m';
CS_MTEX{20}{1}='-3m';
CS_MTEX{21}{1}='6';
CS_MTEX{22}{1}='-6';
CS_MTEX{23}{1}='6/m';
CS_MTEX{24}{1}='622';
CS_MTEX{25}{1}='6mm';
CS_MTEX{26}{1}='-6m2';
CS_MTEX{27}{1}='6/mmm';
CS_MTEX{28}{1}='23';
CS_MTEX{29}{1}='m-3';
CS_MTEX{30}{1}='432';
CS_MTEX{31}{1}='-43m';
CS_MTEX{32}{1}='m-3m';
% 
% (SS) Default triclinic sample symmetry
SS = symmetry('-1');
%
%********************************************************
% specify crystal symmetry
%********************************************************
disp(' ')
disp('      32 Proper rotational point groups in MTEX')
disp('     Crystal system in CAPITALS for Laue classes ')
disp('------:--------------:------------:------:--------:-----------')
disp(' Code : crystal      : Schoen-  : Point  : Laue   : Rotational')
disp('      : system       : flies    : group  : class  : point group')
disp('------:--------------:----------:--------:--------:-----------')
disp('   1  : triclinic    :   C1     :   1    :   -1   :     1')
disp('   2  : TRICLINIC    :   Ci     :  -1    :   -1   :     1')
disp('------:--------------:----------:--------:--------:-----------')
disp('   3  : monoclinic*  :   C2     :   2    :  2/m   :     2')
disp('   4  : monoclinic*  :   Cs     :   m    :  2/m   :     2')
disp('   5  : MONOCLINIC*  :   C2h    :  2/m   :  2/m   :     2')
disp('------:--------------:----------:--------:--------:-----------')
disp('   6  : orthorhombic :   D2     :  222   :  mmm   :    222')
disp('   7  : orthorhombic :   C2v    :  mm2   :  mmm   :    222')
disp('   8  : ORTHORHOMBIC :   D2h    :  mmm   :  mmm   :    222')
disp('------:--------------:----------:--------:--------:-----------')
disp('   9  : tetragonal   :   C4     :   4    :  4/m   :     4')
disp('  10  : tetragonal   :   S4     :  -4    :  4/m   :     4')
disp('  11  : TETRAGONAL   :   C4h    :  4/m   :  4/m   :     4')
disp('------:--------------:----------:--------:--------:-----------')
disp('  12  : tetragonal   :   D4     :  422   : 4/mmm  :    422')
disp('  13  : tetragonal   :   C4v    :  4mm   : 4/mmm  :    422')
disp('  14  : tetragonal   :   D2d    :  -42m  : 4/mmm  :    422')
disp('  15  : TETRAGONAL   :   D4h    :  4/mmm : 4/mmm  :    422')
disp('------:--------------:----------:--------:--------:-----------')
disp('  16  : trigonal     :   C3     :   3    :   -3   :     3')
disp('  17  : TRIGONAL     :   C3i    :  -3    :   -3   :     3')
disp('------:--------------:----------:--------:--------:-----------')
disp('  18  : trigonal     :   D3     :  32    :   -3m  :    32')
disp('  19  : trigonal     :   C3v    :  3m    :   -3m  :    32')
disp('  20  : TRIGONAL     :   D3d    : -3m    :   -3m  :    32')
disp('------:--------------:----------:--------:--------:-----------')
disp('  21  : hexagonal    :   C6     :   6    :   6/m  :     6')
disp('  22  : hexagonal    :   C3h    :  -6    :   6/m  :     6')
disp('  23  : HEXAGONAL    :   C6h    :  6/m   :   6/m  :     6')
disp('------:--------------:----------:--------:--------:-----------')
disp('  24  : hexagonal    :   D6     :  622   : 6/mmm  :    622')
disp('  25  : hexagonal    :   C6v    :  6mm   : 6/mmm  :    622')
disp('  26  : hexagonal+   :   D3h    : -6m2   : 6/mmm  :    622')
disp('  27  : HEXAGONAL    :   D6h    : 6/mmm  : 6/mmm  :    622')
disp('------:--------------:----------:--------:--------:-----------')
disp('  28  : cubic        :   T      :  23    :  m-3   :   23')
disp('  29  : CUBIC        :   Th     :  m-3   :  m-3   :   23')
disp('------:--------------:----------:--------:--------:-----------')
disp('  30  : cubic        :   O      :  432   :  m-3m  :   432')
disp('  31  : cubic        :   Td     :  -43m  :  m-3m  :   432')
disp('  32  : CUBIC        :   Oh     :  m-3m  :  m-3m  :   432')
disp('------:--------------:----------:--------:--------:-----------')
disp(' ')
disp(' * monoclinic setting 2-fold axis is b-axis')
disp(' ')
disp(' + hexagonal point group -6m2 can also written as -62m')
disp(' ')
N_CS = input('Type symmetry code (1-32) ? ', 's');
NCS = str2num(N_CS);

disp(' ')
disp(' To correctly simulate a Laue class of the pole figures')
disp(' they should have a center of symmetry')
disp(' 1 = impose a center of symmetry with antipodal (non-polar) option')
disp(' 2 = only use pure rotational symmetry operations')
Option_antipodal = input('Option  code (1-2) ? ', 's');
N_antipodal = str2num(Option_antipodal);
%
%********************************************************
% List Euler angles of symmetry rotations operations
%********************************************************
%
symmetry(CS_MTEX{NCS}{1})
List_of_Euler_angles_of_symmetry_operations = rotation(symmetry(CS_MTEX{NCS}{1}))
%
%********************************************************
% Setup symmtery options, default a,b,c,alpha,beta,gamma
% and file names
%********************************************************
%
switch CS_MTEX{NCS}{1}
    case {'1','-1'}
% Triclinic point group rotation (C1 - 1) Laue -1
% file name
        plot_title ='Plot_UnimodalODF_Triclinic_poles.png';
% Plagioclase An80 -1
        a_b_c=[8.178,12.87,14.187];
        alpha_beta_gamma=[93.50*degree,115.90*degree,90.65*degree];
    case  {'2','m','2/m'}
% Monoclinic (C2 - 2) Laue 2/m
% file name
        plot_title='Plot_UnimodalODF_Monoclinic_poles.png';
% Diopside (cpx) 2/m
        a_b_c=[9.7460,8.8990,5.2510];
        alpha_beta_gamma=[90.00*degree,105.63*degree,90.00*degree];
    case {'222','mm2','mmm'}
% Orthorhombic (D2 - 222) Laue mmm
% file name
        plot_title='Plot_UnimodalODF_Orthorhombic_poles.png';
% Olivine mmm
        a_b_c=[4.756,10.195,5.981];
        alpha_beta_gamma=[90.00*degree,90.00*degree,90.00*degree];
    case {'4','-4','4/m'}
% Tetragonal low (C4 - 4) Laue 4/m
% file name
        plot_title='Plot_UnimodalODF_Low_Tetragonal_poles.png';
% Rutile 4/m
        a_b_c=[4.5845,4.5845,2.9533];
        alpha_beta_gamma=[90.00*degree,90.00*degree,90.00*degree];
    case {'422','4mm','-42m','4/mmm'}
% Tetragonal high (D4 - 422) Laue 4/mmm
        plot_title='Plot_UnimodalODF_High_Tetragonal_poles.png';
% Stishovite (SiO2) 4/mmm
        a_b_c=[4.1790,4.1790,2.6651];
        alpha_beta_gamma=[90.00*degree,90.00*degree,90.00*degree];
    case {'3','-3'}
% Trigonal low (C3 - 3) Laue -3
% file name
        plot_title='Plot_UnimodalODF_Low_Trigonal_poles.png';
% Dolomite -3
        a_b_c=[4.8069,4.8069,16.0034];
        alpha_beta_gamma=[90.00*degree,90.00*degree,120.00*degree];
    case {'32','3m','-3m'}
% Trigonal high (D3 - 32) Laue -3m
% file name
        plot_title='Plot_UnimodalODF_High_Trigonal_poles.png';
% Quartz -3m
        a_b_c=[4.9133,4.9133,5.4048];
        alpha_beta_gamma=[90.00*degree,90.00*degree,120.00*degree];
    case {'6','-6','6/m'}
% Hexagonal low (C6 - 6) Laue 6/m
% file name
        plot_title='Plot_UnimodalODF_Low_Hexagonal_poles.png';
% Nepheline 6/m
        a_b_c=[9.993,9.993,8.69];
        alpha_beta_gamma=[90.00*degree,90.00*degree,120.00*degree];
    case {'622','6mm','-6m2','6/mmm'}
% Hexagonal high (D6 - 622) Laue 6/mmm
% file name
        plot_title='Plot_UnimodalODF_High_Hexagonal_poles.png';
% Graphite 6/mmm
        a_b_c=[2.456,2.456,6.696];
        alpha_beta_gamma=[90.00*degree,90.00*degree,120.00*degree];
    case {'23','m-3'}
% Cubic low (T - 23) Laue m3
% file name
        plot_title='Plot_UnimodalODF_Low_Cubic_poles.png';
% Pyrite m3
        a_b_c=[5.418,5.418,5.418];
        alpha_beta_gamma=[90.00*degree,90.00*degree,90.00*degree];
    case {'432','-43m','m-3m'}
% Cubic high (O - 432) Laue m3m
% file name
        plot_title='Plot_UnimodalODF_High_Cubic_poles.png';
% Pyrope Garnet m3m 
        a_b_c=[11.988,11.988,11.988];
        alpha_beta_gamma=[90.00*degree,90.00*degree,90.00*degree];
    otherwise
        error('This is impossible')
end
%%
% Define crystal symmetry compatible with HKL/Oxford and Bruker EBSD Systems
CS = symmetry(CS_MTEX{NCS}{1},a_b_c,alpha_beta_gamma,'X||a*','Z||c')
SS = symmetry('-1')
o = orientation('Euler',0*degree,0*degree,0*degree,'bunge',CS,SS)
odf = unimodalODF(o,CS,SS,'halfwidth',10.0*degree)
% texture index
textureindex(odf)
% Extended list of Miller indices - hkl
Miller_Indices_hkl = [Miller(1,0,0,CS,'hkl'),Miller(0,1,0,CS,'hkl'),...
     Miller(0,0,1,CS,'hkl'),Miller(1,1,0,CS,'hkl'),...
     Miller(0,1,1,CS,'hkl'),Miller(1,0,1,CS,'hkl'),...
     Miller(1,1,1,CS,'hkl'),Miller(1,2,3,CS,'hkl'),Miller(3,2,1,CS,'hkl')];
% Extended list of Miller indices - uvw
Miller_Indices_uvw = [Miller(1,0,0,CS,'uvw'),Miller(0,1,0,CS,'uvw'),...
     Miller(0,0,1,CS,'uvw'),Miller(1,1,0,CS,'uvw'),...
     Miller(0,1,1,CS,'uvw'),Miller(1,0,1,CS,'uvw'),...
     Miller(1,1,1,CS,'uvw'),Miller(1,2,3,CS,'uvw'),Miller(3,2,1,CS,'uvw')];
%**************************************************************************
% plot hkls
%**************************************************************************
cla reset;set(gcf,'position',[10   100   1600   400])
%figure('position',[10   100   1600   400])

if( N_antipodal == 1)
  plotpdf(odf,Miller_Indices_hkl,'antipodal')
else
  plotpdf(odf,Miller_Indices_hkl,'complete')    
end
% 3.3.2 annotate
%'data',{'X','Y','Z','-X','-Y','-Z'},'backgroundcolor','w')
% 3.4.2 annotate
annotate([xvector,yvector,zvector,-xvector,-yvector,-zvector],...
'label',{'X','Y','Z','-X','-Y','-Z'},'backgroundcolor','w')
%
% save file name  plus .pdf, .eps. , .png
savefigure('/MatLab_Programs/PFs_hkls.pdf')
%%
%**************************************************************************
% plot uvws
%**************************************************************************
cla reset;set(gcf,'position',[10   100   1600   400])
%figure('position',[10   100   1600   400])
plotpdf(odf,Miller_Indices_uvw,'complete')
% 3.3.2 annotate
annotate([xvector,yvector,zvector,-xvector,-yvector,-zvector],...
'data',{'X','Y','Z','-X','-Y','-Z'},'backgroundcolor','w')
% 3.4.2 annotate
% annotate([xvector,yvector,zvector,-xvector,-yvector,-zvector],...
%'label',{'X','Y','Z','-X','-Y','-Z'},'backgroundcolor','w')
%
% save file name  plus .pdf, .eps. , .png
savefigure('/MatLab_Programs/PFs_uvw.png')
%
disp(' ')
disp(' Script has successfully terminated - plot saved as *png')
disp(' ')
%
% End of script
%