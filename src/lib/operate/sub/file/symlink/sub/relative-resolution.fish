function _symp_operate_file_symlink_relative-resolution --description='Define how the symbolic links should be resolved'
	# Store arguments
	set --function target_parent 	(realpath {$argv[1]} | string split '/')
	set --function source_file 	(realpath {$argv[2]} | string split '/')

	# Strip the common parents
	for parent_el in (seq 1 (count {$target_parent}))
		if test {$target_parent[$parent_el]} = {$source_file[$parent_el]}
			set --function equal_parents_range 1..{$parent_el}
		else
			break
		end
	end
	set --erase source_file[$equal_parents_range] target_parent[$equal_parents_range]

	set --local source_file (string repeat --count=(count {$target_parent}) '../')(string join '/' $source_file) # Relative source path calculated by moving towards the parents
	echo {$source_file}
end
