function _symp_operate_case_recursive_operate-on-children_recurse --description 'Re-operate on a new set of directories'
	_"$program_name"_common_set-output-prefix (status current-function) # Append the Output-prefix with the current function name

	# Verbosity announcement
	if set -q SYMP_VERBOSE # Verbosity announcement
		echo 'Recursing with source: '{$argv[1]}\t'target: '{$argv[2]}
	end

	# Main
	source_dir={$argv[1]} target_path={$argv[2]} "$operate_function"
end
