%Written by C.M. Magazzeni to import Express nanoindentation data from the
%KLA Tencor G200 nanoindenter.
clear()
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Give the basic parameters for the importer

%Set the file to be imported
filename='fusi_3x3_-+91p5umspacing_61x61_1p5umspacing_3mNLCPostcalib.xls'; %filename
filepath='Z:\CM\18_OctEXPRESS\191203_ExpressFUSI\'; %file location (with final \). results will be saved here under xpress_results

batchinfo=[3,3];%INSERT BATCH DIMENSION SIZE:
batchdims=[-91.5 91.5];%SPECIFY SIZE OF EACH BATCH: how many microns are the individuals bundles in the batch separated by? SIGN IS IMPORTANT

[fullres, fullresloc]=load_gridV2(filepath, filename,batchinfo,batchdims); %Loading all the data from the sheet.

plot_fig; %plotting results

%% Save all workspace to .mat file in the results folder
save([fullfile(filepath,[filename(1:length(filename)-4) '_Express_results']) '.mat']);
close all