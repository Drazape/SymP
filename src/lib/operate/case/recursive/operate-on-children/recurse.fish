function _symp_operate_case_recursive_operate-on-children_recurse --description 'Re-operate on a new set of directories'
	_"$program_name"_common_set-output-prefix (status current-function)

	# Verbosity announcement
	if set -q SYMP_VERBOSE # Verbosity announcement
		echo 'Recursing:'\t'Source: '(set_color --bold){$argv[1]}(set_color normal)' target: '(set_color --bold){$argv[2]}(set_color normal)
	end

	# Main
	source_dir={$argv[1]} target_path={$argv[2]} "$operate_function"
end
