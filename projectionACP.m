function [alpha] = projectionACP(E, V, m, q)
    alpha = E(:,1:q)'*(V-m);
end