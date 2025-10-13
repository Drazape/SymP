function _symp_operate_file_blend-link --description "Symlink files while inheriting their parent directory's permission"
	set --append --local --export OUTPUT_PREFIX (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name

	# Parse arguments
	## Switches
	argparse --move-unknown -- {$argv} # Store `ln` arguments

	## Postitional
	### 2 Only
	if test (count {$argv}) -ne '2'
		echo {$OUTPUT_PREFIX} 'Only 2 arguments are accepted' 1>&2
		return 1
	end

	### Set file values
	set --local source_file {$argv[1]}
	set --local target_file {$argv[2]}
	set --erase --local 'argv'



	# RULES for source types
	## Directory: Same permissions
	## File: Same – execution


	# Operation
	## Access
	if set -q blend
		set --local target_parent (path dirname {$target_file})
		### Ownership
		if set -q VERBOSE
			echo {$OUTPUT_PREFIX} 'Setting ownership of Source '\"{$source_file}\"' to that of the new parent'
		end
		set --local new_parent_ownership (stat -c %u:%g {$target_parent})
		chown -R {$new_parent_ownership} {$source_dir}


		### Permissions
		set --local new_parent_octal (stat -c %a -- {$target_parent}) # New Parent directory's octal permissions for setting in source directories
		if set -q VERBOSE # Verbosity announcement
			echo {$OUTPUT_PREFIX} "Permissions of target's parent directory: "{$new_parent_octal}
		end

		#### Calculate octal number for files (Remove executable bit if exists)
		for byte in (string split \0 {$new_parent_octal} | tail -n 3)
			if test (math $byte % 2) -eq 1
				set byte (math $byte - 1)
			end
			set --append --function file_octal {$byte}
		end
		set --function file_octal (string join \0 {$file_octal})
		if set -q VERBOSE # Verbosity announcement
			echo {$OUTPUT_PREFIX} 'File octal calculated: '{$file_octal}
		end

		#### Set new permissions
		if path is -d {$source_file}
			chmod {$new_parent_octal} {$source_file}
			fd . --type=directory {$source_file} --exec-batch chmod {$new_parent_octal} '{}'
			fd . --type=file {$source_file} --exec-batch chmod {$file_octal} '{}'	
		else
			chmod {$file_octal} {$source_file}
		end
	end


	## Link
	ln -s {$VERBOSE} {$behaviour} {$argv_opts} -- {$source_file} {$target_file}
end
