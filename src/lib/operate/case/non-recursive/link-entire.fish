function _symp_operate_case_non-recursive_link-entire --description 'Link entire directory'
	if set -qg SYMP_VERBOSE # Verbosity announcement
		_"$program_name"_common_set-output-prefix (status current-function)
		echo {$output_prefix} 'Target does not exist: "'{$target_path_output}\"
	end

	"$operate_function"_file_symlink -- "$source_dir" "$target_path"
end
