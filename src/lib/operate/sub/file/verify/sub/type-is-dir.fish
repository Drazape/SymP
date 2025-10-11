function _symp_operate_file_verify_type-is-dir --description 'Verify that the source is a directory'
	set --append --local --export OUTPUT_PREFIX (status current-function | string split '_' | tail -n 1)': ' # Append the Output-prefix with the current function name

	for file_path in {$argv}
		if ! path is -d {$file_path}
			echo {$OUTPUT_PREFIX} 'Not a directory: '{$file_path} 1>&2
			exit 1			
		end
	end
	if set -q VERBOSE # Verbosity announcement
		echo {$OUTPUT_PREFIX} 'Verified directories: '{$argv}
	end
end
