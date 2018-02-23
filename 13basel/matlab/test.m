omega = linspace(0,2*pi,3000);

z = - 0.05 + 0.3i + exp(1i .* omega);

plot(real(z),imag(z))

axis equal

%%

v = 0.5 .* ( z + 1./z);

plot(real(v),imag(v),'-')

axis equal

%%

x = 1.05*linspace(-2,2,600);
y = 1.05*linspace(-2,2,600);

[x,y] = meshgrid(x,y);

z = x+1i*y;

w = 0.5 .* ( z + 1./z);

figure(1)

PhasePlot(z,z,'c');

figure(2)

PhasePlot(z,w,'c');

axis equal