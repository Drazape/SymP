function _symp_switch_indi_resolution --description='Parse switch: resolution'
	if ! contains "$argv" 'a' 'absolute'
		set --global --export resolution 'relative'
	else
		set --global --export resolution 'absolute'
	end
end
