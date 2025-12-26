function _symp_operate_file_verify_writability --description='Verify that the source is a directory'
	_"$program_name"_common_set-output-prefix (status current-function)

	for file_path in {$argv}
		# Check for parent-directory if target is not a directory
		if ! path is --type=dir {$file_path}
			set -qg SYMP_VERBOSE && echo {$output_prefix} 'Testing for parent directory of non-directory file '\"(set_color --bold){$file_path}(set_color normal)\"': '(set_color --bold)(path dirname -- {$file_path})(set_color normal)

			set --function file_path (path dirname -- {$file_path})
			set --erase --local 'argv'
		end

		# Check permissions
		if ! path is --perm=write --perm=exec -- {$file_path}
			echo {$output_prefix} 'Unwritable directory: '(set_color --bold)"$file_path"(set_color normal) 1>&2
			exit 1
		end
	end
end
