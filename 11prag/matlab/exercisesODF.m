

%%

cs = symmetry('cubic');
ss = symmetry('-1');


q = axis2quat(vector3d(1,2,3),20*degree);

odf = unimodalODF(q,cs,ss);

%%

figure(1);plotpdf(odf,Miller(1,2,3),'north')
figure(2);plotpdf(odf,Miller(1,2,3),'antipodal')

%%

figure(1);plotipdf(odf,vector3d(1,2,3),'north')
figure(2);plotipdf(odf,vector3d(1,2,3),'antipodal')

%%

figure(1);plotipdf(odf,vector3d(1,0,0),'north')
figure(2);plotipdf(odf,vector3d(1,0,0),'antipodal')
