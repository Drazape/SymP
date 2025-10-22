function _symp_operate_file_verify_writability --description 'Verify that the source is a directory'
	set --append --local --export OUTPUT_PREFIX (status current-function | string split '_' | tail -n 1)': ' # Append the Output-prefix with the current function name

	argparse 'r/recursive&' -- {$argv} or return 1

	function test-perms
		if ! path is --perm=write --perm=exec {$argv}
			echo 'Unwritable directories: '{$argv} 1>&2
			exit 1
		end
	end


	for file_path in {$argv}
		if ! path is -d {$file_path} # Check for parent-directory if target is a file
			if set -q VERBOSE # Verbosity announcement
				echo {$OUTPUT_PREFIX} 'testing for parent directory of non-directory file '\"{$file_path}\"': '(path dirname {$file_path})
			end
			test-perms (path dirname {$file_path})
		else if set -ql _flag_recursive
			fd . --type=directory {$file_path} | while read --local file_path
				test-perms {$file_path}
			end
		end
	end
end
