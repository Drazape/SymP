function _symp_arg_switch_indi_overwrites --description='Parse switch: overwrites' --argument-names='switch_val'
	set --erase --local argv # Unused

	# If the `switch_val` is not in the short form, add an extra `-` to it
	test (count (string split -- \0 {$switch_val})) -ne 1 && set -- switch_val '-'{$switch_val}
	set --global -- overwrites '-'{$switch_val}
end
