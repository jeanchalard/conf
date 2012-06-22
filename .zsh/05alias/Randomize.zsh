alias randomize="ruby -e 'a = ARGV; while not a.empty? do i = rand * a.size; puts a[i]; a -= [a[i]] end'"
