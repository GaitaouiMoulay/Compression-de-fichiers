clear all
close all
clc
format long
tic
fileDefault='Calculator.huf';
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
% Vector= uint8(zeros(1, FileSize)); % vecteur des octets
fileID = fopen(fullfile(path_in, file_in), 'rb'); % ouverture du fichier en mode binaire
Vector = fread(fileID, FileSize, 'uint8'); % lecture des
%%
s=Vector(2)+1;%length_dict_dec
dict_dec1=Vector(3:s+2);%La première colonne du dictionnaire
dict_dec2=Vector(s+3 :s+s+2);%La deuxième colonne du dictionnaire
z2=Vector(s+s+3);%Numéroter les zéros signe_num
ls=Vector(s+s+4);% length de signe_num
signe_num=Vector(s+s+5:s+s+5+ls-1);%Le dictionnaire après l'amendement
le=Vector(s+s+5+ls);%length de extension
ln=Vector(s+s+6+ls);%length de  name
ext=Vector(s+s+7+ls:le+s+s+6+ls);%extension de fichier
name=Vector(le+s+s+7+ls:le+s+s+6+ls+ln);% name de fichier
v1=num2cell(dict_dec1);%Convert array to cell array with consistently sized cells
%%
%Collection de dictionnaires
C={};
 for i=1:length(dict_dec2)
     val=dec2bin(dict_dec2(i));
     val_bin=[];
    for j=1:length(val)
         b=val(j);
         if j==1
            val_bin=[b];
         else
            val_bin=[val_bin,',',b];
            X = str2num(val_bin); 
         end       
     end     
     C=[C,[]; X];
 end
 %%
 signe_ansi=de2bi(signe_num);%Convertir le dictionnaire modifié en décimal
 signe_ansi=signe_ansi';
 signe=signe_ansi(:);%Converti verticalement
 f=length(signe);%Longueur du dictionnaire
signe=signe(1:end-z2);%0 enlever l'excédent
%%
%Encodage du dictionnaire, encodage du nouveau dictionnaire et inversion des similaires
 for i =1:length(signe)   
    digit=C{i};
    p=signe(i);
    if isequal(p,0)
        un=ones(1,length(digit));
        digit=un-digit;
    end  
    C{i}=digit;
 end
%%
 comp=Vector(le+s+s+7+ls+ln:end);%Extraction de code
 nz=Vector(1);%Extraire le nombre de zéros
comp =de2bi(comp);%Convertir en système décimal
comp= fliplr(comp);%Flip array left to right
comp=comp';
comp=comp(:);%Converti verticalement
comp=comp(1:end-nz);%0 enlever l'excédent
dict=[v1,C];%Collecte du dictionnaire
dsig = huffmandeco(comp,dict);%Décryptage
name=char(name)';%Transfert de nom en char
ext=char(ext)';%Transfert de extension en char
file_out=[name ext];%Collection de noms en  extension
filename = fullfile(path_in,file_out);
 [~,name,ext] = fileparts(filename);
tic
%%
%Open dialog box for saving files
 [file,path, ~] = uiputfile('*.*','File Save',filename);
if isequal(file,0) || isequal(path,0)
   disp('User clicked Cancel.')
else
   disp(['User selected ',fullfile(path,file),...
         ' and then clicked Save.'])
end
fid2 = fopen ([path, file],'w');%Ouvrir mon fichier avec le même nom et l'extension est différent
fwrite(fid2, dsig);%Écrivez dans le fichier
fclose(fid2);%Fermez le fichier après l'écriture
