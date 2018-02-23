
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

%% Visualize the Data

figure;
plot(ebsd,'property','phase')

%% define a region

region = [5000 2000;...
  10000 2000;...
  10000 4000;...
  5000 4000;
  5000 2000];

line(region(:,1),region(:,2),'color','r','linewidth',2)

%% restrict to this region

in_region = inpolygon(ebsd,region);

ebsd = ebsd(in_region)

%%

plot(ebsd,'property','phase')

%% 













%% Calculate an ODF

odf_quartz = calcODF(ebsd(2))

%%

h_quartz = [Miller(0,0,1,CS{2}),Miller(1,1,0,CS{2})]

figure;
plotpdf(odf_quartz,h_quartz,'antipodal')

%% getting quartz grains

grains_quartz = link(grains,ebsd(2))

%---auxiliary---
ebsdColorbar(CS{2},'colorcoding','bunge')
ebsdColorbar(CS{2},'colorcoding','bunge2','phi1')
ebsdColorbar(CS{2},'colorcoding','rodrigues')
ebsdColorbar(CS{2})
ebsdColorbar(CS{2},'colorcoding','hkl')
%
cs = CS{2}
ori = SO3Grid(5*degree,cs,symmetry);
c = orientation2color(ori,'bunge')
q = getFundamentalRegion(ori)
v = squeeze(double(Rodrigues(q)));
scatter3(v(:,1),v(:,2),v(:,3),10*ones(size(v(:,3))),c)
set(gcf,'renderer','opengl')
%---         ---

figure;
plot(grains_quartz,'colorcoding','hkl')

%% misorientation

mis_quartz = misorientation(grains_quartz)
hold on,
hist(mis_quartz,120)

%%

misodf_quartz = calcODF(mis_quartz)

%%

plotpdf(misodf_quartz,h_quartz)

q = axis2quat(0,0,1,60*degree)
annotate([q inverse(q)])

%% 

figure;
plotboundary(grains_quartz,'property',q)


%% orthoclase 

odf_orthoclose = calcODF(ebsd(4))

%%

v_orthoclase = [xvector yvector zvector];
h_orthoclase = [Miller(1,0,0,CS{4}),Miller(0,1,0,CS{4}),Miller(0,0,1,CS{4})];

figure,
plotipdf(odf_orthoclose,v_orthoclase)

figure,
plotpdf(odf_orthoclose,h_orthoclase)

%% getting grains of orthoclase

grains_ortho = link(grains,ebsd(4))
plot(grains_ortho)

%%

mis_ortho = misorientation(grains_ortho)
hist(mis_ortho)

%%

odfmis_ortho = calcODF(mis_ortho)

%%


figure,
plotipdf(odfmis_ortho,v_orthoclase)

q_orth = axis2quat(0,0,1,180*degree);

annotate([q_orth inverse(q_orth)])

figure,
plotpdf(odfmis_ortho,h_orthoclase)
annotate([q_orth inverse(q_orth)])


%%

figure;
plotboundary(grains_ortho,'property',q_orth,'delta',10*degree)

%% select individual domains

P1 = polygon([  3960.0124     -313.98599
                5764.5507      724.24155
                 7321.892      699.52185
                9744.4229     -116.22836
                3960.0124     -313.98599])

P2 = polygon([  29470.7461      2306.30256
                9373.62737      1762.46908
                5962.30833      1688.30998
                6036.46744      1243.35532
                10461.2943      921.999176
                15578.2729      378.165705
                29792.1022      501.764221
                29470.7461      2306.30256  ])

P3 = polygon([  15701.8714      3097.33306
                 7074.69497      3492.84831
                -94.0189613      3196.21187
                -143.458368      2256.86315
                   7321.892      2232.14345
                 14218.6892      2429.90107
                 15701.8714      3097.33306])

P4 = polygon([	 8607.31657      5025.46991
                 3218.42127      4432.19703
                 -69.299258      4283.87881
                -143.458368      6137.85655
                 6085.90684      6113.13685
                 10832.0899      5519.86397
                 8607.31657      5025.46991])

grains_domain1 = grains_ortho( inpolygon(grains_ortho,P1) )
grains_domain2 = grains_ortho( inpolygon(grains_ortho,P2) )    
grains_domain3 = grains_ortho( inpolygon(grains_ortho,P3) )    
grains_domain4 = grains_ortho( inpolygon(grains_ortho,P4) )    
             
%% ODFs of domains

odf_domain1 = calcODF(grains_domain1)
odf_domain2 = calcODF(grains_domain2)
odf_domain3 = calcODF(grains_domain3)
odf_domain4 = calcODF(grains_domain4)

%%

