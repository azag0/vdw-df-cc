function ignored = read_ignore(file)

if ~exist(file, 'file')
    ignored = {};
    return
end
f = fopen(file);
l = fgetl(f);
if l == -1, l = ''; end
ignored = regexp(l, '(\S+)', 'tokens');
for i = 1:length(ignored)
    ignored{i} = ignored{i}{1};
end

