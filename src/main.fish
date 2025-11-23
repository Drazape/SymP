#!/usr/bin/env fish
set --global program_name 'symp'

# Behavior setting
## Variables
set --function accept_values 'true' '1' 'yes'
set --function decline_values 'none' 'false' '0' 'no'
### Individual
#### Output prefix
set --global output_prefix {$program_name}':'

#### Interactive
if set --query SYMP_INTERACTIVE || contains "$INTERACTIVE[-1]" {$accept_values}
	set --global -- overwrites '--interactive'
	set --global --export 'SYMP_INTERACTIVE'
end



## Arguments
### Switches
#### Parse
argparse --max-args=2 --name="$program_name" 'v/verbose&' 'h/help&' 'O/overwrites=&!_'"$program_name"'_switch_choice_validate-single interactive force backup' 'b/blend=*&!_'"$program_name"'_switch_choice_multi_validate -iownership -ipermission' 'o/occurrence=+&!_'"$program_name"'_switch_choice_multi_validate -m -icommon -iunique' 'r/resolution=!_'"$program_name"'_switch_choice_validate-single absolute relative' -- {$argv}
_"$program_name"_exit-on-error
set --erase --local _flag_{v,h,O,i,f,b,o,r} # Erase unused short versions
#### Individual
##### Verbose
if set -ql '_flag_verbose' || contains "$VERBOSE" {$accept_values}
	set --global --export SYMP_VERBOSE '--verbose'
end

##### Help
if set -ql '_flag_help'
	_{$program_name}_switch_indi_help-text
	return 0
end


argparse --min-args=2 -- {$argv} # Only allow 2 arguments (If help switch isn't used)
_"$program_name"_exit-on-error

##### Occurrences
begin
	set --local arguments 'common' 'unique'
	if set -ql '_flag_occurrence'
		_"$program_name"_switch_choice_multi --individual={$arguments} --variable=file_occurrence {$_flag_occurrence}
		set --erase --local '_flag_occurrence'
	else if ! set -qx file_occurrence # Default
		set --global --export file_occurrence {$arguments}
	else # Split multiple values if already set
		set --global --export file_occurrence (string split ' ' {$file_occurrence})
	end
end

##### Blend
if set -ql '_flag_blend'
	set --local arguments 'permission' 'ownership'
	_"$program_name"_switch_choice_multi --individual={$arguments} --variable='blend' {$_flag_blend}
	set --erase --local '_flag_blend'
else if set -qx blend # Split multiple values if already set
	set --global --export blend (string split ' ' {$blend})
end

##### Overwrites
if set -ql '_flag_overwrites'
	_"$program_name"_switch_indi_overwrites {$_flag_overwrites}
	set --erase --local '_flag_overwrites'
else if ! set -qgx 'overwrites' # Default
	set --global --export -- overwrites '--force'
end

##### Resolution
if set -ql '_flag_resolution'
	_"$program_name"_switch_indi_resolution {$_flag_resolution}
else if ! set -qgx resolution
	set --global --export resolution 'relative'
end

##### Print Functions
if contains "$LIST_FUNCTIONS" {$accept_values}
	set --global --export SYMP_LIST_FUNCTIONS
end


### Positional
set --global -- source_dir (path normalize -- {$argv[1]})
set --global -- target_path (path normalize -- {$argv[2]})





_"$program_name"_operate # Main Operation
wait # for any recursion in child directories to finish
