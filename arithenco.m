clear all
close all
clc
format long
tic
%%
fileDefault='write.exe';
pathDefault=[pwd,'\Date'];
fullfilename=fullfile(pathDefault, fileDefault);
%Open file selection dialog box
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
% Vector= uint8(zeros(1, FileSize)); % vecteur des octets
fileID = fopen(fullfile(path_in, file_in), 'rb'); % ouverture du fichier en mode binaire
Vector = fread(fileID, FileSize, 'uint8'); % lecture des
sig=uint8(Vector);;%lecture des vector int
%%
% [alphabet,~,seq]=unique(Vector);
% counts = histc(Vector,alphabet);
[alphabet,ia, seq]=unique(sig);
alp=sig(ia);
sgx=alphabet(seq);

counts = histc(sig,alphabet);
la =length(alphabet);

%save(fullfile(path_in, 'counts1'),'counts');
comp1 = arithenco(seq,counts);%Codez chaque lettre
seq1=seq;
counts1=counts;
%save(fullfile(path_in, 'comui'),'comp1');
h=entropy(sig)
%save(fullfile(path_in, 'cedede'),'sig');
%%
%Codage divisé en 8 unités
d=mod(length(comp1), 8)
if  ( d ==0 )
    nz=0
else
    nz=8-d
end
%%
comp_zeros =[comp1; zeros(nz,1)];%Complétude soustrait de 0
comp_ansi=reshape(comp_zeros, 8, length(comp_zeros)/8)';%j divisé en une matrice 8 bits
comp_ansi=uint8(bin2dec(num2str(comp_ansi)));%Convertissez les 8 en un système décimal
%%
n1=size(Vector,1);%Taille du faisceau vectoriel
n2=size(comp1,1)/8;%Taille de cryptage divisée 8
tauxcomp=n1/n2;
ratiocomp=1-1/tauxcomp;
%%
ggg=de2bi(counts);%Convertir en système décimal
[m,n] = size(ggg);
fleerm=floor(m/255)%Flip array left to right
remm=rem(m,255)
ggg=fliplr(ggg);
ggg=ggg';
ggg=ggg(:);%Converti verticalement
%%
%Codage divisé en 8 unités
k=mod(length(ggg), 8)
if  ( k == 0)
    nk=0
else
    nk=8-k
end
%%
ggg_zeros =[ggg; zeros(nk,1)];%Complétude soustrait de 0
ggg_ansi=reshape(ggg_zeros, 8, length(ggg_zeros)/8)';%j divisé en une matrice 8 bits
ggg = reshape(ggg_zeros,[],8);%Convertissez les 8 en un système décimal
ggg=uint8(bin2dec(num2str(ggg)));%Convertissez les 8 en un système décimal
%------------------------
 tt=length(ggg)%Longueur de counts
 fleertt=floor(tt/255)%Round toward negative infinity
 remtt=rem(tt,255);%Remainder after division
nnn=length(Vector);%Longueur de vector
%%

for i=0:nnn
   if(length(Vector)>255)
       l=length(Vector)-255;
  
   end
end
%%
[filepath,name,ext] = fileparts(file_in);%Get parts of file name et ext
name=double(name);%Double-precision arrays
name=name';
name=name(:);%Converti verticalement
ln =length(name);%Longueur de name
ext=double(ext);%%Converti verticalement
ext=ext';
ext=ext(:);%Converti verticalement
le=length(ext);%Longueur de ext
l=length(Vector);%Longueur de vector
dd=floor(l/255);%Round toward negative infinity
ss=rem(l,255);%Remainder after division
%%
fileSave=[nz; nk;fleerm;fleertt;remtt;remm;ln;le;name;ext;dd;ss ;ggg;comp_ansi];%Arranger Enregistrez le fichier zip
%%
%%-----------------------------------------------------------------------------------------
[filepath,name,ext] = fileparts(file_in)%Get parts of file name
file_out=[name,'.arr'];%  save file_out dict comp
save(fullfile(path_in, file_out),'fileSave');%  save file_out dict comp
fileID = fopen(fullfile(path_in, file_out),'w');%%Ouvrir mon fichier avec le même nom et l'extension est différent
fwrite(fileID,fileSave,'uint8','ieee-be');%%Écrivez dans le fichier
fclose(fileID);%%Fermez le fichier après l'écriture