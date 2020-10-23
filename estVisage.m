%renvoit 1 si V est un visage, sinon renvoit 0
function [bool, distAcceptee] = estVisage(E,V,Ref,m,q,skipList)
    maxRef=0;
    maxV=0;
    for j=1:size(Ref,2)
        for i=j:size(Ref,2)
            actuRef = normEuclid(projectionACP(E, Ref(:,j), m, q)-projectionACP(E, Ref(:,i), m, q),q);
            if actuRef>maxRef
                maxRef=actuRef;
            end
        end
        actuV = normEuclid(projectionACP(E, Ref(:,j), m, q)-projectionACP(E, V, m, q),q);
        if actuV>maxV
            maxV=actuV;
        end
    end
    %[numVr,d] = identification(E,V,Ref,m,q,skipList);
    %d=normEuclid(projectionACP(E, V, m, q),q)
    if maxV<=maxRef
        bool=1;
    else
        bool=0;
    end
    
    distAcceptee=maxRef;

end