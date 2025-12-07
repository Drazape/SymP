function _symp_common_set-output-prefix --no-scope-shadowing --description='Set the output prefix for the current function'
	argparse --m{in,ax}=1 'r/reset&' -- {$argv}
	set --erase --local _flag_r # Unused
	set -ql _flag_reset || set --function -- append '--append'

	if set -qg SYMP_LIST_FUNCTIONS
		set --global {$append} output_prefix (set_color --dim)(string split --right --max=1 --fields=2 -- '_' {$argv})':'(set_color normal) # Append the Output-prefix with the current function name
	end
end
