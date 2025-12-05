function _symp_operate --description 'Main operation logic'
	set --function output_prefix "$program_name"': '(status current-function)':' # Reset output-prefix
	set --global operate_function (status current-function)

	"$operate_function"_file_verify

	if ! "$operate_function"_case_non-recursive 	# Simple, Non-recursive operations
		"$operate_function"_case_recursive 	# Complex, Recursive operations (super-set directories)
	end
end
