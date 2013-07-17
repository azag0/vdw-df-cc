function geom = read_geom(file)

[void, name, void] = fileparts(file);
geom.name = name;
dist = regexp(name, '-([\d\.]+)$', 'tokens');
dist = str2double(dist{1}{1});
geom.dist = dist;
f = fopen(file, 'r');
n = sscanf(fgetl(f), '%d');
geom.n = n;
frags = regexp(fgetl(f), 'fragments (\d+) (\d+)', 'tokens');
frags = [str2double(frags{1}{1}) str2double(frags{1}{2})];
geom.frags = frags;
assert(sum(frags)==n);
geom.atoms = struct('elem', {}, 'frag', {}, 'xyz', {});
for i = 1:n
    geom.atoms(i).elem = fscanf(f, '%s', 1);
    geom.atoms(i).xyz = fscanf(f, '%g', 3)';
    if i <= frags(1), frag = 1; else frag = 2; end
    geom.atoms(i).frag = frag;
end
geom.pairs = cell(frags(1), frags(2));
geom.distmat = zeros(frags(1), frags(2));
for i = 1:frags(1)
    for j = 1:frags(2)
        jj = frags(1)+j;
        pair = sort({geom.atoms(i).elem geom.atoms(jj).elem});
        geom.pairs{i, j} = [pair{1} '-' pair{2}];
        geom.distmat(i, j) = norm(geom.atoms(i).xyz-geom.atoms(jj).xyz);
    end
end
fclose(f);
