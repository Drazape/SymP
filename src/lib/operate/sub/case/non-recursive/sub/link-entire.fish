function _symp_operate_case_non-recursive_link-entire --description 'Link entire directory'
	if set -q VERBOSE # Verbosity announcement
		if set -qx LIST_FUNCTIONS
			set --append --function output_prefix (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
		end
		echo {$output_prefix} 'Target Does not exist: "'{$target_path}\"
	end

	"$operate_function"_file_symlink "$source_dir" "$target_path"
	exit 0
end
