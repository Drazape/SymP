function _symp_operate_file_symlink --description="Symlink files while inheriting their parent directory's permission"
	_"$program_name"_common_set-output-prefix (status current-function)
	set --local this_function (status current-function)

	# Parse arguments
	## Switches
	argparse --move-unknown -- {$argv} # Store `ln` arguments
	test "$status" -ne 0 && return 1 # Exit on incorrect arguments


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

	set -qg blend && "$this_function"_inherit {$source_file} {$target_parent} # Access

	## Link
	ln --symbolic --no-target-directory {$resolution} {$SYMP_VERBOSE} {$overwrites} {$argv_opts} -- (realpath --no-symlinks {$source_file}) {$target_file} | string replace -- '->' '→'
end
