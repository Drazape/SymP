#!/usr/bin/env fish
set --global program_name 'symp'

# Behavior setting
## Variables
set --function accepted_values 'true' '1' 'yes'
### Output prefix
set --global output_prefix {$program_name}':'

### Interactive
if contains "$INTERACTIVE" {$accepted_values}
	set --global -- overwrites '--interactive'
	set --global --export 'SYMP_INTERACTIVE'
end


## Arguments
### Switches
#### Parse
argparse --name="$program_name" 'v/verbose&' 'h/help&' 'O/overwrites=&!contains "$_flag_value" i interactive f force' 'b/blend&' 'o/occurrence=&!contains "$_flag_value" c common u unique' 'r/resolution=!contains {$_flag_value} a absolute r relative' -- {$argv}
if test "$status" -ne 0 # Exit on incorrect arguments
	return 1
end
set --erase --local _flag_{v,h,O,i,f,b,o,r,f} # Erase unused short versions
#### Individual
##### Verbose
if set -ql _flag_verbose || contains "$VERBOSE" {$accepted_values}
	set --global --export SYMP_VERBOSE '--verbose'
end

##### Help
if set -ql _flag_help
	_{$program_name}_help-text
	return 0
end

##### Occurrences
if set -ql _flag_occurrence
	set --global --export symp_file_occurrence {$_flag_occurrence}
	set --erase --local _flag_o{,ccurrence}

	# Convert short form into long
	if test "$symp_file_occurrence" = 'c'
		set --global --export symp_file_occurrence 'common'
	else if test "$symp_file_occurrence" = 'u'
		set --global --export symp_file_occurrence 'unique'
	end
end

##### Blend
if set -ql _flag_blend
	set --global --export blend
	set --erase --local _flag_{B,blend}
end

##### Overwrites
if contains "$_flag_overwrites" i interactive
	set --global -- overwrites '--interactive'
	set --global --export SYMP_INTERACTIVE
else
	set --global --export -- overwrites '--force'
end

##### Resolution
if set --query '_flag_resolution'
	set --global --export resolution {$flag_resolution}
else	
	set --global --export resolution 'relative'
end

##### Print Functions
if contains "$LIST_FUNCTIONS" 'true' '1' 'yes'
	set --global --export SYMP_LIST_FUNCTIONS
end


### Positional
#### 1 argument → Set current directory as source
if test (count {$argv}) -eq 1
	set --global source_dir {$PWD}
	set --global target_path (path normalize {$argv[1]})
#### 2 argument → Set 1st argument as Source & 2nd argument as Target
else if test (count {$argv}) -eq 2
	set --global source_dir (realpath {$argv[1]})
	set --global target_path (path normalize {$argv[2]})
#### argument count != 1 or 2 → throw error
else
	echo {$output_prefix} 'Invalid number of arguments' 1>&2
	return 1
end





_"$program_name"_operate # Main Operation
