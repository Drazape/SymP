function _symp_operate_case_recursive_reserve-and-link --description 'Forcefully remove the target and link the source'
	_"$program_name"_common_set-output-prefix (status current-function)

	set -qg SYMP_VERBOSE && echo {$output_prefix} 'Pure subset directory: '{$target_path_output} # Verbosity announcement

	"$operate_function"_file_remove -r -- "$target_path"
	"$operate_function"_file_symlink -n -- "$source_dir" "$target_path"
end
