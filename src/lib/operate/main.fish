function _symp_operate --description 'Main operation logic'
	set --global -- target_path_output (set_color --bold){$target_path}(set_color normal) # Output (only used when the path is to be given in output)

	_"$program_name"_common_set-output-prefix --reset _{$program_name}
	_"$program_name"_common_set-output-prefix (status current-function)

	set --global operate_function (status current-function)

	"$operate_function"_file_verify

	"$operate_function"_case_non-recursive || "$operate_function"_case_recursive
end
