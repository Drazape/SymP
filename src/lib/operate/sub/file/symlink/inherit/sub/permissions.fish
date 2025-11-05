function _symp_operate_file_symlink_inherit_permissions --description='Inherit permissions of the new parent directory'
	set --append --local --export output_prefix (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
	set --local this_function (status current-function)

	set --local source_file {$argv[1]}
	set --local target_parent {$argv[2]}


	set --local new_parent_octal (stat -c %a -- {$target_parent}) # New Parent directory's octal permissions for setting in source directories
	if set -q VERBOSE # Verbosity announcement
		echo {$output_prefix} "Permissions of target's parent directory: "{$new_parent_octal}
	end

	# Calculate octal number for files (Remove executable bit if exists)
	for byte in (string split \0 {$new_parent_octal} | tail -n 3)
		if test (math $byte % 2) -eq 1
			set byte (math $byte - 1)
		end
		set --append --function file_octal {$byte}
	end
	set --function file_octal (string join \0 {$file_octal})
	if set -q VERBOSE # Verbosity announcement
		echo {$output_prefix} 'File octal calculated: '{$file_octal}
	end

	# Set new permissions
	if path is -d {$source_file}
		chmod {$new_parent_octal} {$source_file}
		fd . --type=directory {$source_file} --exec-batch chmod {$new_parent_octal} '{}'
		fd . --type=file {$source_file} --exec-batch chmod {$file_octal} '{}'	
	else
		chmod {$file_octal} {$source_file}
	end
end
