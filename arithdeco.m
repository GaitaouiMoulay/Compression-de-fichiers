clear all
close all
clc
format long
tic
%%
fileDefault='write.arr';
pathDefault=[pwd,'\data'];
fullfilename=fullfile(pathDefault, fileDefault);
[file_in,path_in,indx_in] = uigetfile( ...
{'*.*',  'All Files (*.*)'}, ...
   'Select a File', fullfilename);
if isequal(file_in,0)
   disp('User selected Cancel')
else
   disp(['User selected ', fullfile(path_in, file_in),... 
         ' and filter index: ', num2str(indx_in)])
end
%%
FileInfo = dir([path_in, file_in]); % lecture des propriétés du fichier
FileSize = FileInfo.bytes; % taille du fichier en octets
fileID = fopen(fullfile(path_in, file_in), 'rb'); % ouverture du fichier en mode binaire
Vector = fread(fileID, FileSize, 'uint8'); % lecture des
nz=Vector(1);% Le nombre de zéros comp_ansi
nk=Vector(2);%Le nombre de zéros  counts
fleerm=Vector(3);%Flip array left to right de counts
fleertt=Vector(4);%%Flip array left to right counts
remtt=Vector(5);%Remainder after division
remm=Vector(6);%Remainder after division
length_ggg=255*fleertt+remtt;%
ln=Vector(7);%Longueur de name
le=Vector(8);%Longueur de ext
name=Vector(9:8+ln);%name de fichier
ext=Vector(9+ln:8+ln+le);% ext de fichier
dd=Vector(9+ln+le);%Round toward negative infinity de vecter
ss=Vector(10+ln+le);%%Remainder after division de vecter
counts=Vector(11+ln+le:10+ln+le+length_ggg);% vecter de counts 
comp_ansi=Vector(11+ln+le+length_ggg:end);%vecter de code
name=char(name)';% Character name
ext=char(ext)';%Character ext
file_out=[name ext];% add name et ext
%%
% % % filename = fullfile(path_in,file_out);
% % %  [~,name,ext] = fileparts(filename);
% % %  %Open dialog box for saving files
% % %   [file,path, ~] = uiputfile('*.*','File Save',filename);
% % % if isequal(file,0) || isequal(path,0)
% % %    disp('User clicked Cancel.')
% % % else
% % %    disp(['User selected ',fullfile(path,file),...
% % %          ' and then clicked Save.'])
% % % end
%%
gg=de2bi(counts);%Convert decimal numbers to binary vectors
gg=fliplr(gg);%%Flip array left to right
gg=gg(:);%%Converti verticalement
gg=gg(1:end-nk);%Diminuez les zéros counts
m=255*fleerm+remm ;%Longueur de vector
gg= reshape(gg,[],m);%Reshape arraycollapse
gg=gg';
gg=fliplr(gg);%%Flip array left to right
gg=bi2de(gg);%Convert decimal numbers to binary vectors
comp=de2bi(comp_ansi);%Convert decimal numbers to binary code
comp= fliplr(comp); %Flip array left to right
comp=comp';
comp=comp(:);%Converti verticalement
comp=comp(1:end-nz);%Diminuez les zéros code
%%
%load(fullfile(path_in, 'counts1'));
%load(fullfile(path_in, 'comui'));
%save(fullfile(path_in, 'taha'),'comp');
%%
l=255*dd+ss;%%Longueur de 
dseq = arithdeco(comp,gg,l);%Decode binary code using arithmetic decoding
%%
save(fullfile(path_in, 'cee'),'dseq');%  save file_out dict dseq
%-----------------------------------------------------------------------
%%
filename = fullfile(path_in,file_out);
 [~,name,ext] = fileparts(filename);
 %Open dialog box for saving files
  [file,path, ~] = uiputfile('*.*','File Save',filename);
if isequal(file,0) || isequal(path,0)
   disp('User clicked Cancel.')
else
   disp(['User selected ',fullfile(path,file),...
         ' and then clicked Save.'])
end

%%
fid2 = fopen ([path, file],'w');%%Ouvrir mon fichier avec le même nom et l'extension est différent
fwrite(fid2, dseq);%Écrivez dans le fichier
fclose(fid2);%%Fermez le fichier après l'écriture
% load('D:\AZERTY');
% fv01=isequal(nz1,nz)
% fv02=isequal(nk1,nk)
% fv03=isequal(fleerm1,fleerm)
% fv04=isequal(fleertt1,fleertt)
% fv05=isequal(remtt1,remtt)
% fv06=isequal(remm1,remm)
% fv07=isequal(ln1,ln)
% fv08=isequal(le1,le)
% fv09=isequal(name1,name)
% fv10=isequal(ext1,ext)
% fv11=isequal(dd1,dd)
% fv12=isequal(ss1,ss)
% fv13=isequal(ggg1,countsy)
% fv14=isequal(comp_ansi1, comp_ansi);
% tic