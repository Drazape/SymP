function _symp_operate --description 'Main operation logic'
	if set -qgx 'SYMP_LIST_FUNCTIONS'
		set --global output_prefix (set_color --dim)"$program_name"': operate:'(set_color normal) # Reset output-prefix
	end
	set --global operate_function (status current-function)

	"$operate_function"_file_verify

	if ! "$operate_function"_case_non-recursive 	# Simple, Non-recursive operations
		"$operate_function"_case_recursive 	# Complex, Recursive operations (super-set directories)
	end
end
