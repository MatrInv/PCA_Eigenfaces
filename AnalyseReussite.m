function [X,dimx,dimy]= AnalyseReussite()
% lecture de la base de donnee (des 35 premières images). Sortie de X où chaque colonne représente
% une image.  dimx, et dimy sont la taille des images
X=[];
skipList = [];
n=39;
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

%calcul de la base du sous-espace des eigenfaces
[E,score,latent] = pca(X');

%Analyse de l'erreur en fonction de q
ratioList=ones(size(E,2));
%serie = 'P00A-010E+00';
serie = 'P00A+010E-20';
for qj = 1:size(E,2)
    success=0;
    nbTests=0;
    for id = 1:n
        fname = strcat('yaleB',num2str(id),'_',serie,'.pgm');
        if exist(fname,'file') && sum(ismember(id,skipList))==0
            Ii = imread(fname);
            Vi = double(reshape(Ii,dimx*dimy,1));

            [pred_i,d_i] = identification(E,Vi,X,m,qj,skipList);
            if pred_i==id
                success = success+1;
            end
            nbTests=nbTests+1;
        end
    end
    ratioList(qj)=success/nbTests;
end

figure('Name',strcat('Serie ',serie));
plot(ratioList);

end