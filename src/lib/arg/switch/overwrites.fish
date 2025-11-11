function _symp_arg_switch_overwrites --description='Parse switch: overwrites'
	if contains "$argv" i interactive
		set --global -- overwrites '--interactive'
		set --global --export SYMP_INTERACTIVE
	else
		set --global --export -- overwrites '--force'
	end
end
