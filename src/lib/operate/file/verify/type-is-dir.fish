function _symp_operate_file_verify_type-is-dir --description='Verify that the source is a directory'
	_"$program_name"_common_set-output-prefix (status current-function)

	for file_path in {$argv}
		if ! path is --type=dir -- {$file_path}
			echo {$output_prefix} 'Not a directory: '(set_color --bold)"$file_path"(set_color normal) 1>&2
			exit 2
		end
	end
	set -qg SYMP_VERBOSE && echo {$output_prefix} 'Verified directory: '(set_color --bold){$argv}(set_color normal)
end
