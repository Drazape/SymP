function _symp_operate_file_verify --description='Verify positional arguments (source and target)'
	_"$program_name"_common_set-output-prefix (status current-function)
	set --local this_function (status current-function) # Set function-name for execution on sub-functions

	"$this_function"_unique-files {$source_dir} {$target_path}
	"$this_function"_type-is-dir "$source_dir"
	"$this_function"_writability "$target_path"
end
