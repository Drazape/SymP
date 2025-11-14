function _symp_arg_switch_overwrites --description='Parse switch: overwrites'
	for mode in {$argv}
		# If the mode is not in the short form, add an extra `-` to it
		if test (count (string split \0 {$mode})) -ne 1
			set -- mode '-'{$mode}
		end
		set --global --export -- overwrites '-'{$mode}
	end

	# Default
	if ! set -qgx overwrites
		set --global --export -- overwrites '--force'
	end
end
