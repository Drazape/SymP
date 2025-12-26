function _symp_operate_case_non-recursive_overwrite-entire --description='Overwrite the target'
	_"$program_name"_common_set-output-prefix (status current-function)
	echo {$output_prefix} (set_color --italics)'Warning'(set_color normal)': Target "'{$target_path_output}'" is not a directory'\t'Replacing with symlink' 1>&2
	"$operate_function"_file_symlink -n -- "$source_dir" "$target_path"
end
