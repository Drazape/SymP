function _symp_arg_switch_occurrence --description='Parse switch: occurrence'
	set --global --export symp_file_occurrence {$argv}

	# Convert short form into long
	if test "$symp_file_occurrence" = 'c'
		set --global --export symp_file_occurrence 'common'
	else if test "$symp_file_occurrence" = 'u'
		set --global --export symp_file_occurrence 'unique'
	end
end
