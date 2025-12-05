function _symp_operate_case_non-recursive_link-entire --description 'Link entire directory'
	if set -q SYMP_VERBOSE # Verbosity announcement
		if set -qg SYMP_LIST_FUNCTIONS
			set --append output_prefix (status current-function | string split --right --max=1 --fields=2 -- '_')':' # Append the Output-prefix with the current function name
		end
		echo {$output_prefix} 'Target Does not exist: "'{$target_path}\"
	end

	"$operate_function"_file_symlink -- "$source_dir" "$target_path"
end
