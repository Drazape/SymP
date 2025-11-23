function _symp_switch_choice_validate-single --description='Validate single-choice switches'
	# Allow the first letter of the argument as a short version
	for individual_value in {$argv}
		set --append accept_values {$individual_value} (string sub --end=1 {$individual_value})
	end
	set --erase --local '_flag_individual' # Use complete


	# Check
	for user_choice in "$_flag_value"
		if ! contains "$user_choice" {$accept_values}
			echo 'Unknown value: '{$user_choice}
			return 1
		end
	end
end
