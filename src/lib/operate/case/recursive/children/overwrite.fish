function _symp_operate_case_recursive_children_overwrite --description='Forcefully remove the target item (if it exists) and overwrite it with the source item'
	_"$program_name"_common_set-output-prefix (status current-function)

	set --local -- source_item {$argv[1]}
	set --local -- target_item {$argv[2]}

	test -e {$target_item} && "$operate_function"_file_remove -- "$target_item" # Remove target item if it exists
	"$operate_function"_file_symlink -- "$source_item" "$target_item"
end
