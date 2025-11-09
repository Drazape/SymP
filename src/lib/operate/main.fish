function _symp_operate --description 'Main operation logic'
	if set -qx LIST_FUNCTIONS
		set --append --local output_prefix (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
	end
	set --global operate_function (status current-function)

	"$operate_function"_file_verify

	if ! "$operate_function"_case_non-recursive 	# Simple, Non-recursive operations
		"$operate_function"_case_recursive 	# Complex, Recursive operations (super-set directories)
	end
end
