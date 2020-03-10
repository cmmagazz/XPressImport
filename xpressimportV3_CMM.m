%Written by C.M. Magazzeni to import Express nanoindentation data from the
%KLA Tencor G200 nanoindenter.
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Give the basic parameters for the importer

%Set the file to be imported
filename='express_1x47_+85umspacing_17x17_5umspacing_80umextent_20mNLC.xls'; %filename
filepath='Z:\CM\18_OctEXPRESS\200306_WP1-006\'; %file location (with final \). results will be saved here under xpress_results

batchinfo=[1, 89];%INSERT BATCH DIMENSION SIZE:
batchdims=[85, 85];%SPECIFY SIZE OF EACH BATCH: how many microns are the individuals bundles in the batch separated by? SIGN IS IMPORTANT

[fullres, fullresloc]=load_gridV2(filepath, filename,batchinfo,batchdims); %Loading all the data from the sheet.

plot_fig; %plotting results

%% Save all workspace to .mat file in the results folder
save([fullfile(filepath,[filename(1:length(filename)-4) '_Express_results']) '.mat']);
close all