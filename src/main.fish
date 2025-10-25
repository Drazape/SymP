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
	set --global overwrites --interactive
end


## Arguments
### Switches
#### Parse
argparse --name "$script_name" 'v/verbose&' 'h/help&' 'O/overwrites=&!contains "$_flag_value" i interactive f force' 'b/blend&' 'o/occurrence=&!contains "$_flag_value" c common u unique' -- {$argv}
if test "$status" -ne 0 # Exit on incorrect arguments
	return 1
end
#### Individual
##### Common only
if set -ql _flag_occurrence
	set --global --export symp_file_occurrence {$_flag_occurrence}
	set --erase --local _flag_o{,ccurrence}

	# Convert short form into long
	if test "$symp_file_occurrence" = 'c'
		set symp_file_occurrence 'common'
	else if test "$symp_file_occurrence" = 'u'
		set symp_file_occurrence 'unique'
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
	set --global --export INTERACTIVE
end
if ! set -qgx overwrites
	set --global -- overwrites '--force'
end

##### Verbose
if set -ql _flag_verbose
	if ! set -qgx VERBOSE # Only if not set above
		set --global --export VERBOSE '--verbose'
	end
end

##### Help
if set -ql _flag_help
	_{$script_name}_help-text
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
