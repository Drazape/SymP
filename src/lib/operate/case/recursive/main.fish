function _symp_operate_case_recursive --description 'Recursive operation on super-set directories'
	_"$program_name"_common_set-output-prefix (status current-function)
	set --local this_function (status current-function) # Set function-name for execution on sub-functions


	# Determine if the Target is a pure subset of the Source
	fd . --base-directory "$target_path" | while read --local item_path # Find all files and directories within the target, relative to itself
		if ! test -e "$source_dir"/"$item_path" # Check if the file(s)/directories in the target are also in source
			# A unique file/dir was found in the target. It is not a pure subset
			set -qg SYMP_VERBOSE && echo {$output_prefix} 'Unique file: '(set_color --bold)(path normalize -- "$target_path"/"$item_path")(set_color normal) # Verbosity announcement

			set --function 'impure_subset'
			break
		end
	end


	# Action based on comparison
	if ! set -qf impure_subset && contains 'common' {$file_occurrence} # Target is a pure subset
		"$this_function"_reserve-and-link
	else # Target has unique files. Preserve them by linking contents individually
		"$this_function"_children
	end
end
