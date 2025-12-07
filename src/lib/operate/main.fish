function _symp_operate --description 'Main operation logic'
	if set -qgx 'SYMP_LIST_FUNCTIONS'
		_"$program_name"_common_set-output-prefix --reset _{$program_name}
		_"$program_name"_common_set-output-prefix (status current-function)
	end
	set --global operate_function (status current-function)

	"$operate_function"_file_verify

	"$operate_function"_case_non-recursive || "$operate_function"_case_recursive
end
