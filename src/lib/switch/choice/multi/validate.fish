function _symp_switch_choice_multi_validate --description='Validate dual-choice argparse switches' --inherit-variable='accept_values' --inherit-variable='decline_values'
	argparse --max-args=0 'i/individual=+&' 'm/mandatory&' -- {$argv} 2>&1 # Specify individual flags that are allowed
	set --erase --local _flag_{i,m} # Unused short versions

	set --function accept_values 'true' '1' 'yes' 'none' 'false' '0' 'no' # Initial values (can't be inherited on validation)

	# Define initial values
	if ! set -ql '_flag_mandatory'
		set --append accept_values {$accept_values} \0
		set --erase --local '_flag_mandatory'
	end

	# External configuration
	## Allow entering amount as an argument
	if test (count {$_flag_individual}) -eq 2
		set --append accept_values 'both'
	else
		set --append accept_values 'all'
	end

	## Allow the first letter of the argument as a short version
	for individual_value in {$_flag_individual}
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
