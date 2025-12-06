function _symp_common_set-output-prefix --no-scope-shadowing --description='Set the output prefix for the current function'
	if set -qg SYMP_LIST_FUNCTIONS
		set --append output_prefix (set_color --dim)(string split --right --max=1 --fields=2 -- '_' {$argv})':'(set_color normal) # Append the Output-prefix with the current function name
	end
end
