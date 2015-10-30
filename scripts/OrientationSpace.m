%%                     The Orientation Space
%
%                Ralf Hielscher, TU Chmenitz, Germany
%
%%             TEXMAT-CZM Texture School, Clausthal, 2015
%
% The following script describes different way of visualzing the
% orientation space.
%
% Run this script section by section and follow the output. You are
% encauraged to alter the script to get a better feeling about MTEX.
%
% important shortcuts:
% Strg + Return         - run the current section
% Shift + Strg + Return - run the current section and go to the next one
% F9                    - evaluate the selected command
%

%% Individual orientations
% The most common way to describe orientations is by Euler angles
% (phi1,Phi,phi2). In MTEX this is done using the syntax

cs = crystalSymmetry('432');
ori = orientation('Euler',10*degree,30*degree,37.5*degree,cs)

%%
% Accordingly an orientation can be visualized in a three dimensional plot
% with axes for phi1, Phi and phi2. However, for publications two
% dimensional sections through this three dimensional space are more
% suitable. 

plotSection(ori)

%%
% Often people expect the angle phi1 to be restricted between 0 and 90
% degree. This is true only for orthorombic specimen symmetry. A second
% issue is that individual orientations may fall into the gap between two
% sections. To avoid this one has two options. 
%
% First option: specify the section directly

oS = phi2Sections(ori.CS,ori.SS);
oS.phi2 = 37.5*degree

plotSection(ori,oS)

%%
% Second option: increase the tolerance. Small exercise: how many points
% would you expect and how do you explain the result?

oS = phi2Sections(ori.CS,ori.SS);
oS.tol = 7.5*degree

plotSection(ori.symmetrise,oS)

%% ODF plots
%
% In the same manner as orientations we can also vizualize ODFs, we
% colorize the position of each orientation by the value of the ODF for
% this orientation in multiples of the random distribution (mrd).

plot(ODF.ambiguity1)
mtexColorbar
mtexColorMap LaboTeX

%%
% Exercise 1: The ODF in the figure is quite sharp. How many prefered
% orientations does it have and which crystal symmetry?

%%
% One of the big problems of the representation of an ODF by phi2 sections
% is that the same orientation may appear at different positions in the
% sections.

cs = crystalSymmetry('222')
ori = orientation('Euler',90*degree,0,0,cs);
odf = unimodalODF(ori)
plot(odf,'sections',18)


%%
% A different way of sectioning through the orientation space is to Euler
% angles alpha, beta, game with respect to rotations about Z, Y, Z axis as
% it was suggested by Matthies. Next consider sections of fixed sigma =
% alpha + gamma and use alpha, beta as polar coordinates for a spherical
% representation of the orientation. Such secions through the orientation
% space are called sigma sections.

plot(ODF.ambiguity1,'sigma')

%%
% Sigma sections may be interpreted as follows: The superposition of all
% sigma section gives the c-axis pole figure, i.e., the position of an
% orientation in a sigma section gives the direction of its c-axis. The
% direction of the a-axis changes from section to section and is visualzed
% by the vector field. This ways it is straight forward to read out the for
% any position in a sigma section the corresponding orientation.

plotPDF(odf.ambiguity1,Miller(0,0,1,cs))

%%
% In contrast to phi2 sections sigma any orientation is plotted at exactly
% one spot in the sigma sections (exccept for cubic symmetry)


cs = crystalSymmetry('222')
ori = orientation('Euler',90*degree,0,0,cs);
odf = unimodalODF(ori)
plot(odf,'sections',18,'sigma')


%% The assymetric region
%
% The whole space of all orientations can also be parametrised by
% rotational axis and rotational angle. Scaling the rotational axis by the
% rotational angle we can idetify the space of all orientations with the
% three dimensional ball with radius pi.


oR = fundamentalRegion(crystalSymmetry('1'))
plot(oR)


%%
% In the presence of crystal symmetry one can identify a subregion - the so
% called assymetric region - which contains for each orientation exactly
% one of its symmetrcially equivalent.


oR = cs.fundamentalRegion
hold on
plot(oR,'color','r')
hold on
ori = orientation('Euler',30*degree,40*degree,50*degree,cs);
plot(ori.symmetrise,'MarkerFaceColor','b','MarkerSize',10)
hold off

