function _symp_switch_choice_multi --description='Parse multi-value switches' --inherit-variable='accept_values' --inherit-variable='decline_values'

	argparse 'i/individual=+&' 'v/variable=&' -- {$argv} 2>&1 # Specify individual flags that are allowed
	set --erase --local _flag_{i,v,m}

	# Parse arguments
	## Accept amount
	if test (count {$_flag_individual}) -eq 2
		set --append accept_values 'both'
	else
		set --append accept_values 'all'
	end

	## Supported switches: set value of the variable with the short name to that of the long name
	for long in {$_flag_individual}
		set --function (string sub --end=1 {$long}) {$long}
	end

	## User's choice
	for choice in {$argv}
		## Individual choices: Short → Long
		if set -qf {$choice}
			set choice $$choice
		end
		set --function --prepend choices {$choice} # Reverse values to prioritise last the last ones
	end
	set --erase --local 'argv' # Used



	# Action
	for user_choice in {$choices}
		# None
		if contains {$user_choice} {$decline_values}
			return # Don't set `blend` to anything
		# Accept all
		else if contains {$user_choice} {$accept_values} \0
			set --global {$_flag_variable} {$_flag_individual}
			return
		end
	end
	# Apply individual modes
	for mode in {$_flag_individual}
		if contains {$mode} {$choices}
			set --append --global {$_flag_variable} {$mode}
		end
	end
end
