function _symp_arg_switch_resolution --description='Parse switch: overwrites'
	if contains "$argv" a absolute
		set --global -- resolution '--absolute'
		set --global --export SYMP_INTERACTIVE
	else
		set --global --export -- resolution '--relative'
	end
end
