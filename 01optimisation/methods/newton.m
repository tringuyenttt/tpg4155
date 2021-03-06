function [ x ] = newton(F,x0,n,eps,dx,xSearch)
%Newton's method for finding the minimum of a function.
if (nargin < 6); xSearch =  0.5; end
if (nargin < 5); dx      = 1e-7; end
if (nargin < 4); eps     = 1e-7; end
if (nargin < 3); n       =  100; end

dim = length(x0);

x = zeros(n,dim);
x(1,:) = x0;
dF = zeros(dim,1);
HF = zeros(dim,dim);

U = eye(dim);

for i = 1:(n-1)
    for k = 1:dim
        dF(k) = firstDerivative(F,x(i,:),dx*U(:,k)','mid');
        for l = 1:dim
            HF(k,l) = secondDerivative(F,x(i,:),dx*U(:,k)',dx*U(:,l)');
        end
    end
    
    p = -(HF\dF)';
    p = p/norm(p);
    
    G = @(a) F(x(i,:)+a*p);
    a = lineSearch(G,-xSearch,xSearch);
    x(i+1,:) = x(i,:) + a*p;
    
    if (sqrt(sum((x(i+1,:)-x(i,:)).^2)) < eps)
        break
    end

end
x = x(1:i,:);
end

