%plot fig - CMM script to plot out the various graphs from the data. 
%The following graphs are plotted: Hardness, Modulus, Depth, Load, Surface,
%Hardness/Modulus, and some histograms of hardness.
% CMM 2020

%locations for saving
resultsdir=fullfile(filepath,[filename(1:length(filename)-4) '_Express_results']);
if isdir(resultsdir) == 0; mkdir(resultsdir); end

% Set things as individual arrays:
X=fullresloc(:,:,1); %X and Y positions
Y=fullresloc(:,:,2);
S=fullres(:,:,1);
D=fullres(:,:,2);
L=fullres(:,:,3);
M=fullres(:,:,4);
S2oL=fullres(:,:,5);
H=fullres(:,:,6);%

isdel= X==0 & Y==0;%set places where the location is both 0 to NaN (no data)
X(isdel)=NaN;
Y(isdel)=NaN;
X=X-min(X(:));
Y=Y-min(Y(:));
H(isdel)=NaN;
M(isdel)=NaN;
D(isdel)=NaN;
L(isdel)=NaN;
S(isdel)=NaN;

%For hardness and modulus, some smarter ceilings
ceilingH=1e3; %values over 100GPa
whereHighH=H>ceilingH;
H(whereHighH)=NaN;
whereLowH=H<0;
H(whereLowH)=NaN;
if cleanplotq==1
    H(whereHighH)=nanmean(H(:))+nanstd(H(:));
    if nanmean(H(:))>nanstd(H(:))
        H(whereLowH)=nanmean(H(:))-nanstd(H(:));
    else
        H(whereLowH)=0;
    end
end 

ceilingM=1e6; %values over 100000GPa
whereHighM=M>ceilingM;
M(whereHighM)=NaN;%sanity values
whereLowM=M<0;
M(whereLowM)=NaN;
if cleanplotq==1
    M(whereHighM)=nanmean(M(:))+nanstd(M(:));
    if nanmean(M(:))>nanstd(M(:))
        M(whereLowM)=nanmean(M(:))-nanstd(M(:));
    else
        M(whereLowM)=0;
    end
end

% For the rest, do some sensible things when the instrument divides by 0
D(D>1e300)=NaN;
L(L>1e300)=NaN;
S(S>1e300)=NaN;

% Handy values
meanH=nanmean(H(:));
stdH=nanstd(H(:));
meanM=nanmean(M(:));
stdM=nanstd(M(:));

%% The plotting itself

figure;
hplot=contourf(X,Y,H,455,'LineColor','None');
if meanH>stdH
    caxis([meanH-0.5*stdH meanH+0.5*stdH])
else 
    caxis([min(hplot(:)) meanH+1*stdH])
end
title('Hardness')
xlabel('\mum')
ylabel('\mum')
axis image
c=colorbar;
c.Label.String = 'Hardness (GPa)';
figname=['Hardness Figure ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

%smoothing currently not implemented, but here if need be.
%H2=smoothdata(H,2,'gaussian',7);
%H2=smoothdata(H2,1,'gaussian',7);


%MODULUS PLOT SCRIPT
figure;
hplot=contourf(X,Y,M,455,'LineColor','None');
title('Modulus')
xlabel('\mum')
ylabel('\mum')
axis image
if meanM>stdM
    caxis([meanM-0.5*stdM meanM+0.5*stdM])
else 
    caxis([min(hplot(:)) meanM+1*stdM])
end
c=colorbar;
c.Label.String = 'Modulus (GPa)';
figname=['Modulus Figure ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

%DEPTH PLOT SCRIPT
figure;
hplot=contourf(X,Y,D,455,'LineColor','None');
title('Indentation Depth')
xlabel('\mum')
ylabel('\mum')
axis image
c=colorbar;
c.Label.String = 'Depth (nm)';
figname=['Depth Figure ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

%LOAD PLOT
figure;
hplot=contourf(X,Y,L,455,'LineColor','None');
title('Indentation Load')
xlabel('\mum')
ylabel('\mum')
axis image
c=colorbar;
c.Label.String = 'Load (mN)';
figname=['Load Figure ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

%Tip Position/SURFACE DISPLACEMENT PLOT
figure;
hplot=contourf(X,Y,S,455,'LineColor','None');
title('Surface Displacement Plot')
xlabel('\mum')
ylabel('\mum')
axis image
c=colorbar;
c.Label.String = 'Tip Position (nm)';
figname=['SurfaceDisp Figure ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

%Tip Position/SURFACE DISPLACEMENT PLOT
figure;
hplot=contourf(X,Y,S2oL,455,'LineColor','None');
title('Stiffness Squared over Load Plot')
xlabel('\mum')
ylabel('\mum')
axis image
c=colorbar;
c.Label.String = 'Stiffness ^{2} / Load(N/m)';
figname=['S2oL Figure ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

%Hardness over modulus
HnM=H./M;
figure;
hplot=contourf(X,Y,HnM,455,'LineColor','None');
title('Hardness divided by Modulus')
xlabel('\mum')
ylabel('\mum')
axis image
if nanmean(HnM(:))>nanstd(HnM(:))
    caxis([nanmean(HnM(:))-2*nanstd(HnM(:)) nanmean(HnM(:))+2*nanstd(HnM(:))])
else
    caxis([min(hplot(:)) nanmean(HnM(:))+2*nanstd(HnM(:))])
end
c=colorbar;
c.Label.String = 'Hardness/Modulus';
figname=['HardnessOVMod ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

%% HISTOGRAMS
%Hardness histogram
figure;
hist=histogram(H(:));
title('Histogram of Hardness Measurements')
xlabel('Hardness /GPa')
xlim([0 max(H(:))]) 
ylabel('Number of Indents')
txt = {['Average Hardness: ' num2str(meanH, '%.3g') ' GPa'],['Standard Deviation: ' num2str(stdH, '%.3g') ' GPa']};
text(0.05*max(H(:)),max(hist.Values(:))*0.9,txt)
figname=['Hardness Histogram ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

%Close up of the hardness histogram
figure;
hist=histogram(H(:));
title('Close Up Histogram of Hardness Measurements')
xlabel('Hardness /GPa')
if meanH>stdH
    xlim([meanH-2*stdH meanH+2*stdH]) 
else 
    xlim([0 meanH+2*stdH]) 
end
ylabel('Number of Indents')
figname=['Zoom Hardness Histogram ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')


close all 

%% other small things that should be commented out

%{

logH=log(H);
figure;
hplot=contourf(X,Y,logH,455,'LineColor','None');
title('Log of Hardness')
xlabel('\mum')
ylabel('\mum')
axis image
c=colorbar;
c.Label.String = 'Log Hardness';
figname=['LogHardness Figure ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')
%}
%{
meanHcolumn=nanmean(M);
yposcolumn=nanmean(Y);
meanHcolumnsm=smoothdata(meanHcolumn,2,'gaussian',10);
figure;
plot(yposcolumn,meanHcolumnsm);
%ylim([7 11.5])
xlim([0 3000])
ylabel('Hardness /GPa')
xlabel('Radial Position /\mum')
title('Line profile of hardness along the radius - smoothed by 10 points')
figname=['Hardness Line Profile' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')
saveas(gcf,fullfile(resultsdir, figname),'fig')




H2=H(:,799:end);
H1=H(:,1:799);



meanH1column=nanmean(H1);
meanH2column=nanmean(H2);
yposcolumn=nanmean(Y);
yposcolumn1=yposcolumn(:,1:799);
yposcolumn2=yposcolumn(:,1:715);
meanH1columnsm=smoothdata(meanH1column,2,'gaussian',10);
meanH2columnsm=smoothdata(meanH2column,2,'gaussian',10);
figure;
plot(yposcolumn1,meanH1columnsm);
hold on
plot(yposcolumn2,meanH2columnsm);
%ylim([7 11.5])
xlim([0 3000])
ylabel('Hardness /GPa')
xlabel('Radial Position /\mum')
title('Line profile of hardness along the radius - smoothed by 10 points')
%}
%%
%SOME PLOTTING STUFF PRIMARILY DEBUGGING
%{
imagesc(fullresloc(:,:,1))%LOCATIONS X
axis image

imagesc(fullresloc(:,:,2))%LOCATIONS Y
axis image
fullresr=(fullresloc(:,:,1).^2+fullresloc(:,:,2).^2).^0.5;
imagesc(fullresr)%LOCATIONS R
axis image

figure;
hplot=contourf(X,Y,fullresloc(:,:,1),45,'LineColor','None');
xlabel('\mum')
ylabel('\mum')
axis image
%}