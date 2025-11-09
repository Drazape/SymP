function _symp_operate_file_verify --description 'Verify positional arguments (source and target)'
	if set -qx LIST_FUNCTIONS
		set --append --function output_prefix (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
	end
	set --local this_function (status current-function) # Set function-name for execution on sub-functions

	"$this_function"_type-is-dir "$source_dir"
	"$this_function"_writability "$target_path"
end
