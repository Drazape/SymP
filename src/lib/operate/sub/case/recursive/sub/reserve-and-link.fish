function _symp_operate_case_recursive_reserve-and-link --description 'Forcefully remove the target and link the source'
	set --append --local --export OUTPUT_PREFIX $(status current-function | string split '_' | tail -n 1)': ' # Append the Output-prefix with the current function name

	if set -q VERBOSE # Verbosity announcement
		echo {$OUTPUT_PREFIX} 'Pure subset directory: '{$target_path}
	end

	"$operate_function"_file_remove -r "$target_path"
	"$operate_function"_file_blend-link -n "$source_dir" "$target_path"
end
