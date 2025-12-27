function _symp_operate_file_verify_unique-files --description='Verify that the Source and Target files given are unique'
	_"$program_name"_common_set-output-prefix (status current-function)

	if test {$argv[1]} = {$argv[2]}
		echo {$output_prefix} 'Same Source & Target: '{$target_path_output} 1>&2
		exit 3
	end
end
