function _symp_operate_case_recursive_operate-on-children_recurse --description 'Re-operate on a new set of directories'
	if set -qx SYMP_LIST_FUNCTIONS
		set --append output_prefix (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
	end

	# Parse arguments
	if test (count {$argv}) -ne 2
		echo {$output_prefix} 'Invalid number of arguments' 1>&2
		return 1
	end
	set --local -- source_item {$argv[1]}
	set --local -- target_item {$argv[2]}

	if set -q SYMP_VERBOSE # Verbosity announcement
		echo {$output_prefix} 'Re-operating on directory in Super-set "'{$source_dir}'": '{$source_item}\n'Recursing with source: '{$source_item}\t'target: '{$target_item}
	end

	# Main
	"$program_name" -- "$source_item" "$target_item" &
end
