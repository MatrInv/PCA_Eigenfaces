function [X,dimx,dimy]= lectureYale()
%% function [X,dimx,dimy]= lectureYale()
% lecture de la base de donnee (des 35 premières images). Sortie de X où chaque colonne représente
% une image.  dimx, et dimy sont la taille des images
X=[];
skipList = [];
n=35;
for i=1:n
    filename= sprintf('yaleB%02d_P00A+000E+20.pgm',i);
    %filename=strcat('yaleB',int2str(i),'_P00A+000E+20.pgm');
    if exist(filename,'file')
        disp(i);
      image=imread(filename);
      [dimx dimy ]=size(image);   
       image_colonne=reshape(image, dimx*dimy,1);
       X = [X image_colonne];
    else
        skipList = [skipList i]
    end
    
end
X =  double(X);

%calcul et affichage du visage moyen
m = mean(X,2);
figure('Name','Visage moyen')
imshow(uint8(reshape(m,dimx,dimy)));

%calcul de la base du sous-espace des eigenfaces
[E,score,latent] = pca(X');

%on prend une image I qu'on transforme en V
I = imread('yaleB38_P00A+000E+20.pgm');
%I = imresize(imread('USS_PGM-17-gunboat.pgm'),[dimx dimy]);
%I = imresize(imread('121100909.pgm'),[dimx dimy]);
V = double(reshape(I,dimx*dimy,1));

%On choisit q qui sera la dimension du sous-espace des eigenfaces dans le
%lequel on projettera les visages.
%A noter qu'on ne se creuse pas la tête pas pour choisir cette dimension:
%on va prendre les composantes de l'espace des eigenfaces dans l'ordre croissant de
%leurs indices
q=30;

%calcul et affichage du visage V projeté dans le sous-espace des eigenfaces
alpha = projectionACP(E,V,m,q);
Vp = reconstructionACP(E, m, alpha,q);
figure('Name','Image reconstruite');
imshow(uint8(reshape(Vp,dimx,dimy)));

%somme cumulée normalisée des eigenvalues
cumSumNorm = cumsum(latent) / sum(latent);
figure('Name','Somme cumulée Normalisée des eigenvalues de X');
plot(cumSumNorm);

%identification de Vp
[numVr,d] = identification(E,V,X,m,q,skipList);
msgbox(['Numero visage : ' num2str(numVr) '  |  Distance : ' num2str(d)],'Prediction','modal');

%visage ou non
[bool,dmax] = estVisage(E,V,X,m,q,skipList)
if bool==1
    msg=strcat('Cette image represente un visage. Distance Maximum = ',num2str(dmax));
else
    msg=strcat('Cette image ne represente PAS un visage. Distance Maximum = ', num2str(dmax));
end
msgbox(msg,'Visage ou Non-visage','modal');
end


%%Remarques:

%les images sont stockées en tant que colonne dans X

%reshape(V,h,w) est la fonction qui prend un vecteur V est le convertit en
%matrice h*w de DOUBLE !!!

%Imshow attend des matrices d'ENTIERS !!!