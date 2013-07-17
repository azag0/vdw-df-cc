#!/home/hermann/local/bin/oct
name = regexp(getenv('JOB_NAME'), '(.*).dqs', 'tokens'){1}{1}
run = '/home/hermann/matlab/dft/dispcorr'
system(sprintf('%s %s.param > %s.vdw', run, name, name))
