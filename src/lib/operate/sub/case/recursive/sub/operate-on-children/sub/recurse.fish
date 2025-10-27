function _symp_operate_case_recursive_operate-on-children_recurse --description 'Re-operate on a new set of directories'
	set --append --local --export OUTPUT_PREFIX (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name

	# Parse arguments
	if test (count {$argv}) -ne 2
		echo {$OUTPUT_PREFIX} 'Invalid number of arguments' 1>&2
		return 1
	end
	set --local source_item {$argv[1]}
	set --local target_item {$argv[2]}

	if set -q VERBOSE # Verbosity announcement
		echo {$OUTPUT_PREFIX} 'Re-operating on directory in Super-set "'{$source_dir}'": '{$source_item}\n'Recursing with source: '{$source_item}\t'target: '{$target_item}
	end

	# Main
	"$program_name" "$source_item" "$target_item"
end
