function geoms = read_geoms(geomdir)

xyzs = dir([geomdir filesep '*.xyz']);
geoms = [];
for i = 1:length(xyzs)
    xyz = [geomdir filesep xyzs(i).name];
    geoms = [geoms; read_geom(xyz)];
end
[void, p] = sort([geoms.dist]);
geoms = geoms(p);

