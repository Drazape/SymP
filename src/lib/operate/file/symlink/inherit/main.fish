function _symp_operate_file_symlink_inherit --description='Inherit properties of the new parent directory'
	_"$program_name"_common_set-output-prefix (status current-function) # Append the Output-prefix with the current function name
	set --local this_function (status current-function)

	for blend_mode in {$blend}
		"$this_function"_{$blend_mode} {$argv}
	end
end
