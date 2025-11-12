function _symp_arg_switch_blend --description='Parse switch: blend' --inherit-variable='accept_values'
	set --function individual_modes 'p' 'permission' 'o' 'ownership'

	# Parse arguments
	for i in {$argv}
		## Individual choices: Short → Long
		if test {$i} = 'p'
			set i 'permission'
		else if test {$i} = 'o'
			set i 'ownership'
		end
		set --function --prepend choices {$i} # Reverse values to prioritise last the last ones
	end
	set --erase --local 'argv'

	for user_choice in {$choices}
		# None
		if contains {$user_choice} 'none' 'false' '0' 'no'
			return # Don't set `blend` to anythign
		# Accept all
		else if contains {$user_choice} {$accept_values} 'both' \0
			set --global --export blend {$individual_modes}
			return
		end
	end
	# Apply individual modes
	for mode in {$individual_modes}
		if contains {$mode} {$choices}
			set --append --global --export blend {$mode}
		end
	end
end
