function _symp_operate_case_recursive_children_overwrite --argument-names={source,target}_item --description='Forcefully remove the target item (if it exists) and overwrite it with the source item'
	_"$program_name"_common_set-output-prefix (status current-function)
	set --erase --local argv # Unused (Argument names)

	test -e {$target_item} && "$operate_function"_file_remove -- "$target_item" # Remove target item if it exists
	"$operate_function"_file_symlink -- "$source_item" "$target_item"
end
