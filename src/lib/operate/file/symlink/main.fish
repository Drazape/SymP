function _symp_operate_file_symlink --description="Symlink files while inheriting their parent directory's permission"
	_"$program_name"_common_set-output-prefix (status current-function) # Append the Output-prefix with the current function name
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
	set --function -- source_file {$argv[1]}
	set --function -- target_file {$argv[2]}
	set --erase --local 'argv'



	# Operation
	set --function -- target_parent (path dirname -- {$target_file})

	## Access
	if set -qg blend
		"$this_function"_inherit {$source_file} {$target_parent}
	end

	## Resolution
	if test {$resolution} = 'relative'
		set --function -- relative_path --relative-to={$target_parent}
	end
	set --function -- source_file (realpath --no-symlinks {$relative_path} {$source_file})

	## Link
	ln --symbolic --no-target-directory {$SYMP_VERBOSE} {$overwrites} {$argv_opts} -- {$source_file} {$target_file} | string replace -- '->' '→'
end
