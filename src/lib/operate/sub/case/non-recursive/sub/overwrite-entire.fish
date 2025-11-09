function _symp_operate_case_non-recursive_overwrite-entire --description 'Overwrite the target'
	set --append --local output_prefix (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
	echo {$output_prefix} 'Warning: Target "'{$target_path}'" is not a directory'\t'Replacing with symlink' 1>&2
	"$operate_function"_file_symlink -n "$source_dir" "$target_path"
	exit 0
end
