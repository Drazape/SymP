function _symp_arg_switch_resolution --description='Parse switch: resolution'
	if ! contains "$argv" 'a' 'absolute'
		set --global --export resolution 'relative'
	else
		set --global --export resolution 'absolute'
	end
end
