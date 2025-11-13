function _symp_operate_case_recursive_operate-on-children --description 'Operate individually on contents of `$target_path`'
	set --local this_function (status current-function) # Set function-name for execution on sub-functions
	if set -qx SYMP_LIST_FUNCTIONS
		set --append --function output_prefix (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
	end

	for item in (command ls -A "$source_dir") # Items in source content
		if set -q SYMP_VERBOSE # Verbosity announcement
			echo {$output_prefix} 'Processing item: '{$item}
		end
		set --local source_item "$source_dir"/"$item"
		set --local target_item "$target_path"/"$item"

		if path is --type=dir "$source_item"
			"$this_function"_recurse "$source_item" "$target_item"

			set --local recurse_status {$status}
			if test "$recurse_status" -ne 0
				exit {$recurse_status}
			end
		else
			if test -e "$target_item"
				if contains 'common' {$file_occurrence}
					"$this_function"_overwrite "$source_item" "$target_item"
				end
			else if contains 'unique' {$file_occurrence}
				"$this_function"_overwrite "$source_item" "$target_item"
			end
		end
	end
end
