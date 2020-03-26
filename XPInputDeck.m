%% This is the input deck, and the only file which should need editing
% Here you will input the filepath, filename, and various details of the
% express data
%% Then, you simply need to right click > run on the file xpressimport 
% CM Magazzeni 2020

% The file to be imported
filename='express_singlebundle_95x95_0p9umspacing_0p03mNLC.xls'; %filename
filepath='Z:\CM\18_OctEXPRESS\200311_PR382\'; %file location (with final \)
% results will be saved here under express_results

batchinfo=[1, 1];%Batch size (see help below)
batchdims=[85, 85];%Batch dimensions: how many microns are the 
%individuals bundles in the batch separated by? SIGN IS IMPORTANT
cleanplotq = 1; %clean up NaN values?

%Express maps contain batches of bundles:
%    a bundle
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x  .. x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%        :                  :
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x  .. x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%  x  x  x  x  x     x  x  x  x  x 
%  \_____________________________/
%        the batch of bundles
% In this case, a 2 x 2 batch of 5x5 indent bundles