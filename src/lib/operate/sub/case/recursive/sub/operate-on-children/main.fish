function _symp_operate_case_recursive_operate-on-children --description 'Operate individually on contents of `$target_path`'
		set --local this_function (status current-function) # Set function-name for execution on sub-functions
		set --append --local --export OUTPUT_PREFIX (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name

	for item in (command ls -A "$source_dir") # Items in source content
		if set -q VERBOSE # Verbosity announcement
			echo {$OUTPUT_PREFIX} 'Processing item: '{$item}
		end
		set --local source_item "$source_dir"/"$item"
		set --local target_item "$target_path"/"$item"

		if path is -d "$source_item"
			"$this_function"_recurse "$source_item" "$target_item"
		else
			if set -qg common_only
				if test -e "$target_item"
					"$this_function"_overwrite "$source_item" "$target_item"
				end
			else
				"$this_function"_overwrite "$source_item" "$target_item"
			end
		end
	end
end
