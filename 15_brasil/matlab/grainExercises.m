%%             MTEX Workshop Belo Horizonte 2015
%
%%                      Exercises
%
%                Ralf Hielscher (1) and David Mainprice (2)
%
%  (1) TU Chemnitz, Germany
%  (2) Universite Montpellier, France
%
% The following script guides you through the analysis of an Forsterite
% sample. The original script by David Mainprice was about 800 lines. I
% removed all the code and encourage you to rewrite it. You may find some
% hints on the way.
%
% important shortcuts:
% Strg + Return         - run the current section
% Shift + Strg + Return - run the current section and go to the next one
% F9                    - evaluate the selected command
%

%% Data Import
%
% Have a first look at the data. Which phases are present?

% this imports some sample MTEX data
mtexdata csl
plotx2east


%% Exercise 1
% Visualize the EBSD map according to orientations



%% Exercise 2
% Compute grains and plot the grain boundaries at top of the orientation
% map.



%% Exercise 3
% Colorize the grain boundaries according the misorientation angle.


%% Exercise 4
% Extract all iron to iron grain boundaries. What is its total length?
%
% useful commands: gB.segLength -> length of a grain boundary segment



%% Exercise 5
% Visualize all non iron to iron grain boundaries.



%% Exercise 6
% Find all CSL(3) boundaries within the list of iron to iron grain
% boundaries. As a threshold use 3 degree.
% What is the relative length of CSL(3) grain boundaries in comparison to
% all iron to iron grain boundaries?


%% Exercise 7
% Visualize the CSL(3) grain boundaries on top of a grain plot


%%  Exercise 8
% Are there also other CSL boundaries present? Determine their relative
% length and visualize them in a grain plot.

