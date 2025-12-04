function _symp_operate_case_recursive_reserve-and-link --description 'Forcefully remove the target and link the source'
	if set -qx SYMP_LIST_FUNCTIONS
		set --append output_prefix (status current-function | string split --right --max=1 --fields=2 -- '_')':' # Append the Output-prefix with the current function name
	end

	if set -q SYMP_VERBOSE # Verbosity announcement
		echo {$output_prefix} 'Pure subset directory: '{$target_path}
	end

	"$operate_function"_file_remove -r -- "$target_path"
	"$operate_function"_file_symlink -n -- "$source_dir" "$target_path"
end
