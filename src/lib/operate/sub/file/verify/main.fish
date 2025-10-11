function _symp_operate_file_verify --description 'Verify positional arguments (source and target)'
	set --append --local --export OUTPUT_PREFIX (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
	set --local this_function (status current-function) # Set function-name for execution on sub-functions

	"$this_function"_type-is-dir "$source_dir"
	"$this_function"_writability "$target_path" "$source_dir"
end
