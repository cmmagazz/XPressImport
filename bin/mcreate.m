function mcreate(scriptname)  %and use variable names that have meaning
   scriptname = sprintf('%s.m', scriptname);
   fid = fopen(scriptname, 'wt'); %and use 't' with text files so eol are properly translated
    % Load it up with the lines of code you want in it.
    fprintf(fid, 'clc;\n');
    fprintf(fid, 'close all;\n');
    fprintf(fid, 'clear;\n');
    fprintf(fid, 'workspace;\n');
    fprintf(fid, 'format compact;\n');
    fprintf(fid, 'format long g;\n');
    % Close the file.
    fclose(fid);
    % Open the file in the editor.
    edit(scriptname);
end