function [numVr,d] = identification(E,V,Ref,m,q,skipList)
    min = Inf;
    index = 0;
    Vp = projectionACP(E,V,m,q);
    for i=1:size(Ref,2)
        actu = normEuclid(Vp-projectionACP(E,Ref(:,i),m,q),q);
        if actu<min
            index=i;
            min=actu;
        end
    end
    %on utilise la skipList pour renvoyer le bon numéro en tenant compte
    %des numéros absents dans la base de visage
    cpt=0;
    for j=1:size(skipList)
        if skipList(j)<=index
            cpt=cpt+1;
        else
            break;
        end
    end
    numVr=index+cpt;
    d=min;
end