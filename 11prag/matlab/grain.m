mtexdata 3d

[grains ebsd] = calcGrains(ebsd,'threshold',5*degree)

o = get(grains,'orientations');
rgb = orientation2color(o,'ipdf');

model = export(grains,'grains.mesh',rgb*255,1)

%%

save_idtf('grains_all.idtf',model)
idtf2u3d('grains_all.idtf','grains_all.u3d')
