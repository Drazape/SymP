function _symp_arg_switch_choice_multi_completion-providing-blend-value --description='Check if a value is given to the switch: blend'
    string match --quiet --regex -- '^(--blend=|-b)\w*$' "$(commandline --current-process --current-token)"
end
