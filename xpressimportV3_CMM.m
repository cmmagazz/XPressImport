%Written by C.M. Magazzeni to import Express nanoindentation data from the
%KLA Tencor G200 nanoindenter.
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Give the basic parameters for the importer

%Set the file to be imported
filename='express_singlebundle_95x95_0p9umspacing_0p03mNLC.xls'; %filename
filepath='Z:\CM\18_OctEXPRESS\200311_PR382\'; %file location (with final \). results will be saved here under xpress_results

batchinfo=[1, 1];%INSERT BATCH DIMENSION SIZE:
batchdims=[85, 85];%SPECIFY SIZE OF EACH BATCH: how many microns are the individuals bundles in the batch separated by? SIGN IS IMPORTANT

[fullres, fullresloc]=load_gridV2(filepath, filename,batchinfo,batchdims); %Loading all the data from the sheet.

plot_fig; %plotting results

%% Save all workspace to .mat file in the results folder
save([fullfile(filepath,[filename(1:length(filename)-4) '_Express_results']) '.mat']);
close all