function [fullres, fullresloc] = load_grid(filepath, filename, batchinfo, batchdims) 
tempfp=fullfile([filepath, filename]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Identify the number of tests within the file, and create a cell array to hold their names.
[~,bundleinfoTOTHeader]=xlsread(tempfp,'Required Inputs','C1:J1'); %bundle info headers: 1:X Data Dimension, 2:Depth, 2:Y Data Dimension
bundleinfoTOT=xlsread(tempfp,'Required Inputs','C3:J3'); %bundle info: 1:X Data Dimension, 2:Depth, 2:Y Data Dimension
bundleinfo=bundleinfoTOT(6:8);%just pick the size of the bundle
if strcmp(bundleinfoTOTHeader(7),'Y Data Dimension')
    LvDC=2;
elseif strcmp(bundleinfoTOTHeader(8),'Y Data Dimension')
    LvDC=3;
else 
    'ERROR: sheet is not structured properly, no Y Data Dimension';
end
bundleinfoy=bundleinfo(LvDC);
pixelsizeX=(bundleinfoTOT(1)-bundleinfoTOT(3))/(bundleinfo(1)-1);
pixelsizey=(bundleinfoTOT(2)-bundleinfoTOT(4))/(bundleinfoy-1);

%create cell of fullres version: i.e. bundle*batch
fullres=zeros(batchinfo(1)*bundleinfo(1),batchinfo(2)*bundleinfoy,6);
fullresloc=zeros(batchinfo(1)*bundleinfo(1),batchinfo(2)*bundleinfoy,2);

%5 is from number of useful data values: data values obtained: displacement
%into surface 1 , load on sample 2, modulus 3, stiffness 4, and hardness 5
tic
% EFFICIENT
for bigx=1:batchinfo(1)
    for bigy=1:batchinfo(2)
        %Nanoindenter does serpentine motion for batches: it does not wrap
        %around. This bit of code gets the right sheet for non-serpentine
        %motion. Will break if the X/Y Start is smaller than X /Y
        %Stop (in the bundle)
        if mod(bigy,2) == 1
            sheettemp1=batchinfo(1)*(bigy-1)+bigx; %if it's an odd line
        else
            sheettemp1=batchinfo(1)*(bigy-1)+(batchinfo(1)-(bigx-1)); %if it's an even line
        end
        fprintf('Bundlenumber x=%3i Bundlenumber y=%3i Sheet ID=%3i\n',bigx,bigy,sheettemp1) %diagnostics: where are we?
        if sheettemp1<10 %SORT OUT ZEROS: sheet names aren't computer friendly
            sheettemp=strcat('00',num2str(sheettemp1));
        elseif sheettemp1<100
            sheettemp=strcat('0',num2str(sheettemp1));
        elseif sheettemp1>=100
            sheettemp=num2str(sheettemp1);
        end
        sheetpull=['Test' ' ' sheettemp ' Tagged'];%pull out the right sheet
        %check if the sheet exists, otherwise, remove the word "Tagged"
        try
            xlsread(tempfp,sheetpull,'A1:A1');
        catch
            sheetpull=['Test' ' ' sheettemp];%Change name
            xlsread(tempfp,sheetpull,'A1:A1');
        end
        celllim=num2str(bundleinfo(1)*bundleinfoy+2);
        sheetinmat=xlsread(tempfp,sheetpull,strcat('A3:H',celllim));
        for k=1:bundleinfo(1)
            for l=1:bundleinfoy
                %define variables to get the directions right
                if batchdims(1)<0
                    dirx=(bundleinfo(1)-k+1);
                else
                    dirx=k;
                end
                if batchdims(2)<0
                    diry=(bundleinfoy-l+1);
                else
                    diry=l;
                end
                try
                    fullres((bigx-1)*bundleinfo(1)+dirx,(bigy-1)*bundleinfoy+diry,1:6)=sheetinmat((k-1)*bundleinfo(1)+l,1:6);%get the quantitative values
                    fullresloc((bigx-1)*bundleinfo(1)+dirx,(bigy-1)*bundleinfoy+diry,1)=sheetinmat((k-1)*bundleinfo(1)+l,7)+bigx*batchdims(1);%get the location id
                    fullresloc((bigx-1)*bundleinfo(1)+dirx,(bigy-1)*bundleinfoy+diry,2)=sheetinmat((k-1)*bundleinfo(1)+l,8)+bigy*batchdims(2);%get the location id
                catch
                    fullres((bigx-1)*bundleinfo(1)+dirx,(bigy-1)*bundleinfoy+diry,:)=[NaN,NaN,NaN,NaN,NaN, NaN];
                    %fullres((bigx-1)*bundleinfo(1)+(bundleinfo(1)-k+1),(bigy-1)*bundleinfoy+(bundleinfoy-l+1),:)=[0,0,0,0,0];

                end
            end
        end
    end
end
toc
disp('Loading complete')
end
