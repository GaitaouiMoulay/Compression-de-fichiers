clear all
close all
clc
format long
tic
fileDefault='Calculator.exe';
pathDefault=[pwd,'\Date'];
fullfilename=fullfile(pathDefault, fileDefault);
%%
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
fileID = fopen(fullfile(path_in, file_in), 'rb'); % ouverture du fichier en mode binaire
Vector = fread(fileID, FileSize, 'uint8'); % lecture des
%%
sig=uint8(Vector);%lecture des vector int
symbols=unique(sig);%Choisissez vous-même des cartes sans répétition.
freq=histc(symbols,unique(symbols));%Répétez l'opération pour chaque lettre
p=freq./sum(freq);%La probabilité de chaque lettre
h=entropy(sig)
dict = huffmandict(symbols,p);%Obtenez un dictionnaire
comp = huffmanenco(sig,dict);%Codez chaque lettre
k=mod(length(comp), 8);%Codage divisé en 8 unités
if  ( k == 0)
    nz=0
else
    nz=8-k
end
comp_zeros =[comp; zeros(nz,1)];%Complétude soustrait de 0
comp_ansi=reshape(comp_zeros, 8, length(comp_zeros)/8)';%j divisé en une matrice 8 bits
comp_ansi=uint8(bin2dec(num2str(comp_ansi)));%Convertissez les 8 en un système décimal
n1=size(Vector,1)%Taille du faisceau vectoriel
n2=size(comp,1)/8%Taille de cryptage divisée 8
tauxcomp=n1/n2
ratiocomp=1-1/tauxcomp
%------------------------
dict_dec1=[];
dict_dec2=[];
signe=[];
%%L'inverse de chaque encodage commence par 0 dans le dictionnaire
for i=1:length(dict)
    dict_dec1 =[dict_dec1; dict{i,1}];
    digit=dict{i,2};
    firstbit=dict{i,2}(1);
    if isequal(firstbit,0)
       un=ones(1,length(digit));
       digit=un-digit;
    end
    signe=[signe; firstbit];
    dict_dec2=[dict_dec2; bin2dec(num2str(digit))];
end
%%------------------------------------------------------------------
z2=mod(8-mod(length(signe), 8),8);%%Calculez le nombre de zéros pour former un tableau à 8 colonnes
signe_zeros=[signe; zeros(z2,1)];%%Former le numéro 0 nécessaire pour ma nouvelle matrice
signe_ansi=reshape(signe_zeros, 8, length(signe_zeros)/8)';%Formation de la nouvelle matrice
signe_num=bi2de(signe_ansi);%Convert binary vectors to decimal numbers
ls=length(signe_num);%Longueur de faisceau 
ffff=double(file_in);%Double-precision arrays
[filepath,name,ext] = fileparts(file_in);%Extraire le nom et l'extension de fichier à compresser
name=double(name);%Convertir le nom en double
name=name';
name=name(:);%Conversion de l'horizontale à la verticale
ln =length(name);%Longueur de name
ext=double(ext);%Convertir le ext en double
ext=ext';
ext=ext(:);%Conversion de l'horizontale à la verticale
le =length(ext);%Longueur de extension 

ld=length(dict_dec2)-1;%256-1=255
 fileSave=[nz; ld; dict_dec1; dict_dec2;z2;ls;signe_num;le;ln;ext;name; comp_ansi];%Arranger Enregistrez le fichier zip
%-----------------------------
[filepath,name,ext] = fileparts(file_in);%
file_out=[name,'.huf'];%  save file_out dict comp
save(fullfile(path_in, file_out),'dict','fileSave');
fileID = fopen(fullfile(path_in, file_out),'w');%Ouvrir mon fichier avec le même nom et l'extension est différent
fwrite(fileID,fileSave,'uint8','ieee-be');%Écrivez dans le fichier
fclose(fileID);%Fermez le fichier après l'écriture


