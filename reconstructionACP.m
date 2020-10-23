function [Vp] = reconstructionACP(E, m, alpha, q)
    tmp=ones(32256,1);
    for i=1:q
        tmp = tmp + E(:,i)*alpha(i);
    end
    Vp = m + tmp;
end