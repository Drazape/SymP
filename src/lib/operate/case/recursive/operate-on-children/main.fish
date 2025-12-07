function _symp_operate_case_recursive_operate-on-children --description 'Operate individually on contents of `$target_path`'
	set --local this_function (status current-function) # Set function-name for execution on sub-functions
	_"$program_name"_common_set-output-prefix (status current-function)

	for source_item in "$source_dir"/{,.}* # Items in source content
		set -qg SYMP_VERBOSE && echo {$output_prefix} 'Processing item: '(set_color --bold){$source_item}(set_color normal) # Verbosity announcement
		set --local -- target_item "$target_path"/(path basename -- "$source_item")

		if path is --type=dir -- "$source_item"
			"$this_function"_recurse "$source_item" "$target_item"
		else
			if test -e "$target_item"
				contains 'common' {$file_occurrence} && "$this_function"_overwrite "$source_item" "$target_item"
			else if contains 'unique' {$file_occurrence}
				"$this_function"_overwrite "$source_item" "$target_item"
			end
		end
	end
end
