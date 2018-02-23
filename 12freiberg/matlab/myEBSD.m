
%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {'not indexed',...
    symmetry('-1',[8.169,12.851,7.1124],[93.63,116.4,89.46]*degree,'mineral','Andesina An28'),...
    symmetry('-3m',[4.913,4.913,5.504],'a||y','mineral','Quartz-new'),...
    symmetry('2/m',[5.339,9.249,20.196],[95.06,90,90]*degree,'mineral','Biotite'),...
    symmetry('2/m',[8.5632,12.963,7.2099],[90,116.07,90]*degree,'mineral','Orthoclase')};

% specimen symmetry
SS = symmetry('-1');

% plotting convention
plotx2east

%% Specify File Names

% path to files
pname = '';

% which files to be imported
fname = {...
    [pname 'P5629U1.txt'], ...
    };

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,SS,'interface','generic' ...
    , 'ColumnNames', { 'Index' 'Phase' 'x' 'y' 'Euler1' 'Euler2' 'Euler3' 'MAD' 'BC' 'BS' 'Bands' 'Error' 'ReliabilityIndex' 'EDXCount1' 'EDXCount2' 'EDXCount3' 'EDXCount4' 'EDXCount5' 'EDXCount6'})


