addpath([pwd filesep 'matlab']);

% part First of section II.C of our paper

geoms = read_geoms('geoms');
geoms = read_vdws(geoms, 'vdws');

[pairs, void, ix] = unique(geoms(1).pairs);
p = length(pairs);
m = length(geoms);
vdw_curves = cell(p, 1);
iref = 1;
for i = 1:p
    ixi = ix==i;
    n = sum(ixi);
    rr = zeros(m, n);
    y = zeros(m, 1);
    for j = 1:m
        rr(j, :) = geoms(j).distmat(ixi)';
        y(j) = sum(geoms(j).vdws(ixi));
	end
    xy = decom(rr, y);
    vdw_curves{i} = xy;
    if i > 1 && xy(1, 1) < vdw_curves{iref}(1, 1)
        iref = i;
    end
end

% part Second of section II.C of our paper

geoms = read_energies(geoms, 'cc.data');
geoms = read_energies(geoms, 'dft.data');

n = numel(geoms(1).distmat);
rr = zeros(m, n);
wr = zeros(m, n);
for j = 1:m
    rr(j, :) = geoms(j).distmat(:)';
    for k = 1:n
        wr(j, k) = vint(rr(j, k),...
			            vdw_curves{strcmp(geoms(j).pairs{k}, pairs)})...
                   /vint(rr(j, k), vdw_curves{iref});
    end
end
y = [geoms.cc]'-[geoms.dft]';
corr_curve = decomw(rr, wr, y);

% produce and print final pair curves

f = fopen('pair-curves.txt', 'w');
pair_curves = cell(p, 1);
for i = 1:p
	lb = max([vdw_curves{i}(1, 1) corr_curve(1, 1)]);
	ri = lb:0.1:20;
	pair_curves{i} = [ri'...
		vint(ri, corr_curve).*...
			(vint(ri, vdw_curves{i})./vint(ri, vdw_curves{iref}))];
	fprintf(f, '%s\n', pairs{i});
	fprintf(f, '%-10g %g\n', pair_curves{1}');
	fprintf(f, '\n');
end
fclose(f);

% produce figures

dists = [geoms.dist]';
energies = [[geoms.cc]' [geoms.dft]'];
for j = 1:m
	energies(j, 3) = energies(j, 2) + sum(geoms(j).vdws(:));
	s = 0;
	for k = 1:n
		XY = pair_curves{strcmp(geoms(j).pairs{k}, pairs)};
		s = s + interp1(XY(:, 1), XY(:, 2), geoms(j).distmat(k));
	end
	energies(j, 4) = energies(j, 2) + s;
end
plot(dists, energies)
