function _symp_arg_switch_occurrence --description='Parse switch: blend' --inherit-variable='accept_values'
	set --function individual_modes 'permission' 'ownership'

	# Singular choice
	for user_choice in {$argv}
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
		if contains {$mode} {$argv}
			set --append --global --export blend {$mode}
		end
	end
end
