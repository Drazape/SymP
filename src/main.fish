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
if contains "$INTERACTIVE" {$accept_values}
	set --global -- overwrites '--interactive'
	set --global --export 'SYMP_INTERACTIVE'
end

#### Blend
if set -qx blend
	set --global --export blend (string split ' ' {$blend})
end


## Arguments
### Switches
#### Parse
argparse --max-args=2 --name="$program_name" 'v/verbose&' 'h/help&' 'O/overwrites=&!contains "$_flag_value" i interactive f force' 'b/blend=*&!_symp_arg_switch_multi-choice_validate -iownership -ipermission' 'o/occurrence=+&!_symp_arg_switch_multi-choice_validate -m -icommon -iunique' 'r/resolution=!contains {$_flag_value} a absolute r relative' -- {$argv}
if test "$status" -ne 0 # Exit on incorrect arguments
	exit 1
end
set --erase --local _flag_{v,h,O,i,f,b,o,r} # Erase unused short versions
#### Individual
##### Verbose
if set -ql '_flag_verbose' || contains "$VERBOSE" {$accept_values}
	set --global --export SYMP_VERBOSE '--verbose'
end

##### Help
if set -ql '_flag_help'
	_{$program_name}_arg_switch_help-text
	return 0
end

##### Occurrences
if set -ql '_flag_occurrence'
	set --local arguments 'common' 'unique'
	_symp_arg_switch_multi-choice --individual={$arguments} --variable=file_occurrence {$_flag_occurrence}
	set --erase --local '_flag_occurrence'
end

##### Blend
if set -ql '_flag_blend'
	set --local arguments 'permission' 'ownership'
	_symp_arg_switch_multi-choice --individual={$arguments} --variable='blend' {$_flag_blend}
	set --erase --local '_flag_blend'
end

##### Overwrites
if set -ql '_flag_overwrites'
	_symp_arg_switch_overwrites {$_flag_overwrites}
	set --erase --local '__flag_overwrites'
end

##### Resolution
if set -ql '_flag_resolution'
	set --global --export resolution {$flag_resolution}
	set --erase --local '_flag_resolution'
else
	set --global --export resolution 'relative'
end

##### Print Functions
if contains "$LIST_FUNCTIONS" {$accept_values}
	set --global --export SYMP_LIST_FUNCTIONS
end


### Positional
_symp_arg {$argv}





_"$program_name"_operate # Main Operation
wait # for any recursion in child directories to finish
