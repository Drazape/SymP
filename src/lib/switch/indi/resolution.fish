function _symp_switch_indi_resolution --description='Parse switch: resolution'
	if ! contains "$argv" 'a' 'absolute'
		set --global resolution 'relative'
	else
		set --global resolution 'absolute'
	end
end
