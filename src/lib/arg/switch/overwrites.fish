function _symp_arg_switch_overwrites --description='Parse switch: overwrites'
	# If the argv is not in the short form, add an extra `-` to it
	if test (count (string split -- \0 {$argv})) -ne 1
		set -- argv '-'{$argv}
	end
	set --global --export -- overwrites '-'{$argv}

	# Default
	if ! set -qgx overwrites
		set --global --export -- overwrites '--force'
	end
end
