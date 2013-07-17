function geoms = read_vdws(geoms, vdwdir)

vdws = dir([vdwdir filesep '*.vdw']);
for n = 1:length(vdws)
    vdw = [vdwdir filesep vdws(n).name];
    [void, name, void] = fileparts(vdw);
    k = find(strcmp(name, {geoms.name}), 1);
    geom = geoms(k);
    enes = load(vdw);
    geoms(k).vdws = geom.distmat;
    m = 1;
    for i = 1:geom.frags(1)
        for j = 1:geom.frags(2)
            geoms(k).vdws(i, j) = enes(m);
            m = m+1;
        end
    end
end

