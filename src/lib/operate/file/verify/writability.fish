function _symp_operate_file_verify_writability --description 'Verify that the source is a directory'
	if set -qx SYMP_LIST_FUNCTIONS
		set --append output_prefix (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
	end

	for file_path in {$argv}
		# Check for parent-directory if target is not a directory
		if ! path is --type=dir {$file_path}
			if set -q SYMP_VERBOSE # Verbosity announcement
				echo {$output_prefix} 'testing for parent directory of non-directory file '\"{$file_path}\"': '(path dirname {$file_path})
			end
			set --function file_path (path dirname {$file_path})
			set --erase --local 'argv'
		end

		# Check permissions
		if ! path is --perm=write --perm=exec -- {$file_path}
			echo {$output_prefix} 'Unwritable directory: '"$file_path" 1>&2
			exit 1
		end
	end
end
