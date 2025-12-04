function _symp_common_set-output-prefix --no-scope-shadowing --description='Set the output prefix for the current function'
	if set -qx SYMP_LIST_FUNCTIONS
		set --append output_prefix (string split --right --max=1 --fields=2 -- '_' {$argv})':' # Append the Output-prefix with the current function name
	end
end
