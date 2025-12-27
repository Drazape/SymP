function _symp_arg_count --description='Verify the number of files'
	argparse 'a/allow=&' -- {$argv}
	set --erase --local _flag_a # Unused short flag

	if test (count {$argv}) -ne {$_flag_allow} # Only allow 2 arguments (If help switch isn't used)
		echo {$output_prefix} 'Expected '(set_color --bold){$_flag_allow}(set_color normal)' paths; got '(set_color --italics)(count {$argv})(set_color normal) 1>&2
		exit 1
	end
end
