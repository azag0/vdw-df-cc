function geoms = read_energies(geoms, file)

[void, field, void] = fileparts(file);
[names, enes] = textread(file, '%s %f');
for i = 1:length(enes)
    k = find(strcmp(names{i}, {geoms.name}), 1);
    geoms(k).(field) = enes(i);
end
