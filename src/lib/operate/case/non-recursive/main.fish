function _symp_operate_case_non-recursive --description 'Simple, Non-recursive operations'
	_"$program_name"_common_set-output-prefix (status current-function) # Append the Output-prefix with the current function name
	set --local this_function (status current-function) # Set function-name for execution on sub-functions

	# If target doesn't exist, simply create a symlink to the source and exit
	if ! test -e "$target_path"
		if test "$file_occurrence" != 'common'
			if set -q SYMP_VERBOSE # Verbosity announcement
				echo (set_color --dim){$output_prefix}(set_color normal) 'Non-existant target: '{$target_path_output}\t'linking entire source'
			end

			"$this_function"_link-entire
		end
	# If target is not a directory, it's a conflict. Overwrite it as a symlink.
	else if ! path is --type=dir -- "$target_path"
		if test "$file_occurrence" != 'unique'
			if set -q SYMP_VERBOSE # Verbosity announcement
				echo (set_color --dim){$output_prefix}(set_color normal) 'Non-directory target: '{$target_path_output}\t'Overwriting entire target'
			end

			"$this_function"_overwrite-entire
		end
	else
		return 1
	end
end
