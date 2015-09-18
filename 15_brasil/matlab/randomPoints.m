function pts = randomPoints(N)

x = linspace(0,1,1000);
density = Gaussian(x,0.2,0.05) + Gaussian(x,0.5,0.2);

pts = discretesample(density ./ mean(density), N)/length(density);

end


