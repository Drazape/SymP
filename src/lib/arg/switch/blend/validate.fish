function _symp_arg_switch_blend_validate --description='Validate the argparse switch: blend' --inherit-variable 'accept_values'
	set --function values_for_blend 'both' {$accept_values} \0 'p' 'permission' 'o' 'ownership'
	set --function values_for_normal 'none' 'false' '0' 'no'

	for user_choice in {$_flag_value}
		if ! contains {$user_choice} {$values_for_blend} {$values_for_normal}
			echo 'Unknown value'
			return 1
		else if contains {$user_choice} {$values_for_blend} && contains {$user_choice} {$values_for_normal}
			echo 'Incompatible values: '"$values_for_blend"' and '"$values_for_normal"
			return 2
		end
	end
end
