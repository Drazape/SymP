function _symp_completion_providing-blend-value --description='Check if a value is given to the switch: blend'
	string match --quiet --regex -- '^(--blend=|-b)\w*$' "$(commandline --current-process --current-token)"
end
