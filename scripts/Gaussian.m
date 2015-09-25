function v = Gaussian(x,m,s)

% normal distribution
v =  exp(-(x-m).^2./s^2) ./s./sqrt(pi);


end


