%plot fig - CMM script to plot out the various graphs from the data. 
%The following graphs are plotted: Hardness, Modulus, Depth, Load, Surface,
%Hardness/Modulus, and some histograms of hardness.

%locations for saving
resultsdir=fullfile(filepath,[filename(1:length(filename)-4) '_Express_results']);
if isdir(resultsdir) == 0; mkdir(resultsdir); end

H=fullres(:,:,6);%HARDNESS
H(H>1000)=0;
meanH=nanmean(H(:));
stdH=nanstd(H(:));
is2rem= H>8*nanmedian(H(:)); %remove things outside 3*median (0's fixed later)
H(is2rem)=NaN;
X=fullresloc(:,:,1); %X and Y positions
Y=fullresloc(:,:,2);
isdel= X==0 & Y==0;%set places where the location is both 0 to NaN (no data)
X(isdel)=NaN;
Y(isdel)=NaN;
H(isdel)=NaN;
X=X-min(X(:));
Y=Y-min(Y(:));
figure;
hplot=contourf(X,Y,H,455,'LineColor','None');
%caxis([3 9.5]);
title('Hardness')
xlabel('\mum')
ylabel('\mum')
axis image
c=colorbar;
c.Label.String = 'Hardness (GPa)';
figname=['Hardness Figure ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

%% smoothing currently not implemented, but here if need be.
%H2=smoothdata(H,2,'gaussian',7);
%H2=smoothdata(H2,1,'gaussian',7);

%%
%MODULUS PLOT SCRIPT
M=fullres(:,:,4);
is2rem= M>3*nanmedian(M(:)); %remove things outside 3*median (0's fixed later)
M(is2rem)=NaN;
X=fullresloc(:,:,1); %X and Y positions
Y=fullresloc(:,:,2);
isdel= X==0 & Y==0;%set places where the location is both 0 to NaN (no data)
X(isdel)=NaN;
Y(isdel)=NaN;
M(isdel)=NaN;
X=X-min(X(:));
Y=Y-min(Y(:));
figure;
hplot=contourf(X,Y,M,455,'LineColor','None');
title('Modulus')
xlabel('\mum')
ylabel('\mum')
axis image
c=colorbar;
c.Label.String = 'Modulus (GPa)';
figname=['Modulus Figure ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')


%DEPTH PLOT SCRIPT
D=fullres(:,:,2);
is2rem= D>10*nanmedian(D(:)); %remove things outside 3*median (0's fixed later)
D(is2rem)=NaN;
X=fullresloc(:,:,1); %X and Y positions
Y=fullresloc(:,:,2);
isdel= X==0 & Y==0;%set places where the location is both 0 to NaN (no data)
X(isdel)=NaN;
Y(isdel)=NaN;
D(isdel)=NaN;
X=X-min(X(:));
Y=Y-min(Y(:));
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
L=fullres(:,:,3);
is2rem= L>3*nanmedian(L(:)); %remove things outside 3*median (0's fixed later)
L(is2rem)=NaN;
X=fullresloc(:,:,1); %X and Y positions
Y=fullresloc(:,:,2);
isdel= X==0 & Y==0;%set places where the location is both 0 to NaN (no data)
X(isdel)=NaN;
Y(isdel)=NaN;
L(isdel)=NaN;
X=X-min(X(:));
Y=Y-min(Y(:));
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
S=fullres(:,:,1);
is2rem= S>3*nanmedian(S(:)); %remove things outside 3*median (0's fixed later)
S(is2rem)=NaN;
X=fullresloc(:,:,1); %X and Y positions
Y=fullresloc(:,:,2);
isdel= X==0 & Y==0;%set places where the location is both 0 to NaN (no data)
X(isdel)=NaN;
Y(isdel)=NaN;
S(isdel)=NaN;
X=X-min(X(:));
Y=Y-min(Y(:));
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

%Hardness over modulus
HnM=H./M;
figure;
hplot=contourf(X,Y,HnM,455,'LineColor','None');
title('Hardness divided by Modulus')
xlabel('\mum')
ylabel('\mum')
axis image
caxis([0 0.05]);
c=colorbar;
c.Label.String = 'Hardness/Modulus';
figname=['HardnessOVMod ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')
%%
%HISTOGRAMS
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


figure;
hist=histogram(H(:));
title('Close Up Histogram of Hardness Measurements')
xlabel('Hardness /GPa')
xlim([meanH-2*stdH meanH+2*stdH]) 
ylabel('Number of Indents')
figname=['Zoom Hardness Histogram ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')




close all 
disp 'Express Import Complete'



%%
%SOME PLOTTING STUFF PRIMARILY DEBUGGING
%{
imagesc(fullresloc(:,:,1))%LOCATIONS X
axis image
% 
 imagesc(fullresloc(:,:,2))%LOCATIONS Y
 axis image
% 
% fullresr=(fullresloc(:,:,1).^2+fullresloc(:,:,2).^2).^0.5;
% imagesc(fullresr)%LOCATIONS R
% axis image

figure;
hplot=contourf(X,Y,Y,45,'LineColor','None');
title('Indentation Depth')
xlabel('\mum')
ylabel('\mum')
axis image
c=colorbar;
%}