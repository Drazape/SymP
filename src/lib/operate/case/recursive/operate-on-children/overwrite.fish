function _symp_operate_case_recursive_operate-on-children_overwrite --description 'Forcefully remove the target item (if it exists) and overwrite it with the source item'
	_"$program_name"_common_set-output-prefix (status current-function) # Append the Output-prefix with the current function name


	# Parse arguments
	if test (count {$argv}) -ne 2
		echo (set_color --dim){$output_prefix}(set_color normal) 'Invalid number of arguments' 1>&2
		return 1
	end
	set --local -- source_item {$argv[1]}
	set --local -- target_item {$argv[2]}

	if test -e {$target_item}
		"$operate_function"_file_remove -- "$target_item" # Remove target item if it exists
	end
	"$operate_function"_file_symlink -- "$source_item" "$target_item"
end
