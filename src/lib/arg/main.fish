function _symp_arg --description='Parse arguments'
	#### 1 argument → Set current directory as source
	if test (count {$argv}) -eq 1
		set --global source_dir {$PWD}
		set --global target_path (path normalize {$argv[1]})
	#### 2 argument → Set 1st argument as Source & 2nd argument as Target
	else if test (count {$argv}) -eq 2
		set --global source_dir (realpath {$argv[1]})
		set --global target_path (path normalize {$argv[2]})
	#### argument count != 1 or 2 → throw error
	else
		echo {$output_prefix} 'Invalid number of arguments' 1>&2
		return 1
	end
end
