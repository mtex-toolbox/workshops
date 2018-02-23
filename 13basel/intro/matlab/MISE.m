function e = MISE(odf,psi,N,rep)
%


%% 
e = zeros(1,rep);
for r = 1:rep
  
  ebsd = simulateEBSD(odf,N,'silent'); 
  
  eodf = calcODF(ebsd,'kernel',psi,'silent');
  
  e(r) = calcError(odf,eodf);
  
end

e = mean(e);