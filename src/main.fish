#!/usr/bin/env fish
set --global script_name 'symp'

# Behaviour setting
## Variables
### Output prefix
set --global --export OUTPUT_PREFIX {$script_name}':'

### Verbose
if set -qlx VERBOSE
	set --global --export VERBOSE '--verbose'
end

### Interactive
if set -qlx INTERACTIVE
	set --global behaviour --interactive
end


## Arguments
### Switches
#### Parse
argparse --name "$script_name" 'v/verbose&' 'h/help&' 'b/behaviour=&!_'"$script_name"'_switches_validate-behaviour' 'B/blend&' 'c/common-only&' -- {$argv}
if test "$status" -ne 0 # Exit on incorrect arguments
	return 1
end
#### Individual
##### Common only
if set -q _flag_common_only
	set --global --export common_only
	set --erase --local _flag_c _flag_common_only
end

##### Blend
if set -q _flag_blend
	set --global --export blend
	set --erase --local _flag_B _flag_blend
end

##### Behaviour
if contains "$_flag_behaviour" i interactive
	set --global -- behaviour '--interactive'
	set --global --export INTERACTIVE
end
if ! set -qgx behaviour
	set --global -- behaviour '--force'
end

##### Verbose
if set -ql _flag_verbose
	if ! set -qgx VERBOSE # Only if not set above
		set --global --export VERBOSE '--verbose'
	end
end

##### Help
if set -ql _flag_help
	_{$script_name}_switches_help-text
	return 0
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
	echo {$OUTPUT_PREFIX} 'Invalid number of arguments' 1>&2
	return 1
	set --erase argv
end




_"$script_name"_operate # Main Operation
