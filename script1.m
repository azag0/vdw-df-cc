addpath([pwd filesep 'matlab']);
args = argv();
queue = args{1};
[geomdir, moldendir, vdwdir] = deal('geoms', 'moldens', 'vdws');
submit = 'qsub -cwd -l mem=1G -V -q %s %s';

cwd = pwd();
cd(vdwdir);
moldens = dir([cwd filesep moldendir filesep '*.wf']);
for i = 1:length(moldens)
    molden = [cwd filesep moldendir filesep moldens(i).name];
    [void, name, void] = fileparts(molden);
    paramfile = [name '.param'];
    dqsfile = [name '.dqs'];
    xyzfile = [name '.xyz'];
    copyfile([cwd filesep 'dqs.m'], dqsfile);
    % prepare param file
    copyfile([cwd filesep 'param'], paramfile);
    f = fopen(paramfile, 'a');
    fprintf(f, 'molden = %s\n', molden);
    geom = read_geom([cwd filesep geomdir filesep xyzfile]);
    fprintf(f, 'frags = %i %i\n', geom.frags(1), geom.frags(2));
    fclose(f);
    % submit dqs file
    system(sprintf(submit, queue, dqsfile));
end

