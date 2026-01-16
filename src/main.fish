#!/usr/bin/env fish

# The main executable of the program
# This is only run once and not included in any recursion of the program at individual directories
# The job it is to parse all the external input into something easily readable by the program internally


set --global program_name 'symp'

# Behavior setting
## Variables
set --function accept_values 'true' '1' 'yes'
set --function decline_values 'none' 'false' '0' 'no'
### Individual
#### Output prefix
set --global output_prefix (set_color --dim){$program_name}':'(set_color normal)

#### Interactive
if set -qgx SYMP_INTERACTIVE || contains "$INTERACTIVE[-1]" {$accept_values}
	set --global -- overwrites '--interactive'
	set --global 'SYMP_INTERACTIVE'
end



## Arguments
### Switches
#### Parse
argparse --name={$program_name} 'v/verbose&' 'h/help&' 'O/overwrites=&!_'"$program_name"'_arg_switch_choice_validate-single interactive force backup' 'b/blend=*&!_'"$program_name"'_arg_switch_choice_multi_validate -i{ownership,permission}' 'o/occurrence=+&!_'"$program_name"'_arg_switch_choice_multi_validate -m -i{common,unique}' 'r/resolution=!_'"$program_name"'_arg_switch_choice_validate-single absolute relative' -- {$argv}
_"$program_name"_common_exit-on-error
set --erase --local _flag_{v,h,O,i,f,b,o,r} # Erase unused short versions
#### Individual
##### Verbose
if set -ql '_flag_verbose' || contains "$VERBOSE" {$accept_values}
	set --global SYMP_VERBOSE '--verbose'
end

##### Help
if set -ql '_flag_help'
	_{$program_name}_arg_switch_indi_help-text
	return
end


_"$program_name"_arg {$argv}
set --erase --local argv # Used
_"$program_name"_common_exit-on-error

##### Occurrences
begin
	set --local arguments 'common' 'unique'
	if set -ql '_flag_occurrence'
		_"$program_name"_arg_switch_choice_multi --individual={$arguments} --variable=file_occurrence {$_flag_occurrence}
		set --erase --local '_flag_occurrence'
	else
		set --global file_occurrence {$arguments}
	end
end

##### Blend
if set -ql '_flag_blend'
	_"$program_name"_arg_switch_choice_multi --individual={'permission','ownership'} --variable='blend' {$_flag_blend}
	set --erase --local '_flag_blend'
end

##### Overwrites
if set -ql '_flag_overwrites'
	_"$program_name"_arg_switch_indi_overwrites {$_flag_overwrites}
	set --erase --local '_flag_overwrites'
else
	set --global -- overwrites '--force'
end

##### Resolution
contains "$_flag_resolution" 'a' 'absolute' || set --global -- resolution '--relative'

##### Print Functions
contains "$LIST_FUNCTIONS" {$accept_values} && set --global SYMP_LIST_FUNCTIONS





_"$program_name"_operate # Main Operation
wait # for any recursion in child directories to finish
