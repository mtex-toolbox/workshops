%% The density

% normal distribution
N = @(x,m,s) exp(-(x-m).^2./s^2) ./s./sqrt(pi);

x = linspace(0,1,100);
density = N(x,0.2,0.05) + N(x,0.5,0.2);
density = density ./ mean(density);

% save density
ss = [x(:),density(:)];
save('example.txt','ss','-ascii');


%% random samples

for d = 1:3
  ny = 20^d;
  y{d} =  discretesample(density, ny)/length(density);

  sss = [y{d}(:),zeros(ny,1)];
  save(['sample_' num2str(d) '.txt'],'sss','-ascii');
end

%% histogram

[n,xout] = hist(y{1},7)

xout = xout - (xout(2)-xout(1))/2;
xout(end+1) = xout(end)+(xout(2)-xout(1));

sss = [xout(:),[n(:);n(end)]/sum(n)*12];
save(['hist.txt'],'sss','-ascii');



%% kernel density estimators

hold off
plot(x,density,'-k','linewidth',2)
hold on

s = 0.075; 
d = 1;
z = zeros(1,length(x));
ssz = [];

for i = 1:length(y{d})
  zz = N(x,y{1}(i),s) ./ length(y{1});
  ssz =[ssz,zz(:)]; %#ok<AGROW>
  z = z + zz;
end

plot(x,z,'-b','linewidth',2)
ss = [x(:),density(:),z(:),ssz];
save('example.txt','ss','-ascii');

hold off
%%

hold off
plot(x,density,'-k','linewidth',2)
hold on

d = 2;
s = 0.05; 

z2 = zeros(1,length(x));
for i = 1:length(y{d})
  z2 = z2 + N(x,y{2}(i),s) ./ length(y{2});
end


plot(x,z2,'-b','linewidth',2)
ss = [x(:),density(:),z(:),z2(:),ssz];
%save('example.txt','ss','-ascii');

hold off


%%

s = [0.025,0.05,0.1,0.2];
for is = 1:length(s)

  hold off
  plot(x,density,'-k','linewidth',2)
  
  hold on
  scatter(x(y),zeros(length(y),1),100,'r','linewidth',2)
  

  
  for i = 1:length(y)
    plot(x,N(x,x(y(i)),s(is))./length(y),'r');
  end
  pause;
  %savefigure(['1d_' num2str(is) '.pdf']);
end

%%


plot(kernel('de la Vallee Poussin','halfwidth',10*degree),'K','symmetric')
savefigure('dvp_10.pdf')

%%

plot(kernel('jackson',20),'K','symmetric')
%ylim([-10,90])
%ylim([-50,650])
ylim([-300,4800])
savefigure('jackson_20.pdf')
