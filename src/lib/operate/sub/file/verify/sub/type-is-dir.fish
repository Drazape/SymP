function _symp_operate_file_verify_type-is-dir --description 'Verify that the source is a directory'
	if set -qx SYMP_LIST_FUNCTIONS
		set --append output_prefix (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
	end

	for file_path in {$argv}
		if ! path is --type=dir {$file_path}
			echo {$output_prefix} 'Not a directory: '"$file_path" 1>&2
			exit 1			
		end
	end
	if set -q SYMP_VERBOSE # Verbosity announcement
		echo {$output_prefix} 'Verified directory: '{$argv}
	end
end
