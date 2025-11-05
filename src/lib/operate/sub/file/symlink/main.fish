function _symp_operate_file_symlink --description="Symlink files while inheriting their parent directory's permission"
	set --append --local --export output_prefix (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
	set --local this_function (status current-function)

	# Parse arguments
	## Switches
	argparse --move-unknown -- {$argv} # Store `ln` arguments
	if test "$status" -ne 0 # Exit on incorrect arguments
		return 1
	end


	## Postitional
	### 2 Only
	if test (count {$argv}) -ne '2'
		echo {$output_prefix} 'Only 2 arguments are accepted' 1>&2
		return 1
	end

	### Set file values
	set --function source_file {$argv[1]}
	set --function target_file {$argv[2]}
	set --erase --local 'argv'



	# Operation
	set --function target_parent (path dirname {$target_file})

	## Access
	if set -q blend
		"$this_function"_inherit {$source_file} {$target_parent}
	end

	## Resolution
	if test "$resolution" = 'relative'
		set --function source_file (realpath --relative-to={$target_parent} {$source_file})
	end

	## Link
	ln -s {$VERBOSE} {$overwrites} {$argv_opts} -- {$source_file} {$target_file}
end
