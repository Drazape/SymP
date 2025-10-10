function _smart-symlink_operate_case_non-recursive --description 'Simple, Non-recursive operations'
	set --append --local --export OUTPUT_PREFIX (status current-function | string split '_' | tail -n 1)': ' # Append the Output-prefix with the current function name
	set --local this_function (status current-function) # Set function-name for execution on sub-functions

	# If target doesn't exist, simply create a symlink to the source and exit
	if ! test -e "$target_path"
		if set -q VERBOSE # Verbosity announcement
			echo 'Non-existant target: '{$target_path}\t'linking entire source'
		end

		"$this_function"_link-entire
	# If target is not a directory, it's a conflict. Overwrite it as a symlink.
	else if ! test -d "$target_path"
		if set -q VERBOSE # Verbosity announcement
			echo 'Non-directory target: '{$target_path}\t'Overwriting entire target'
		end

		"$this_function"_overwrite-entire
	end
end
