function out = sem(x,dim)

if nargin==1, 
  % Determine which dimension SUM will use
  dim = find(size(x)~=1, 1 );
  if isempty(dim), dim = 1; end

  out = std(x,0,dim)/sqrt(size(x,dim)-1);
else
  out = std(x,0,dim)/sqrt(size(x,dim)-1);
end
