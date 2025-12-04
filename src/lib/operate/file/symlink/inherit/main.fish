function _symp_operate_file_symlink_inherit --description='Inherit properties of the new parent directory'
	if set -qx SYMP_LIST_FUNCTIONS
		set --append output_prefix (status current-function | string split --right --max=1 --fields=2 -- '_')':' # Append the Output-prefix with the current function name
	end
	set --local this_function (status current-function)

	for blend_mode in {$blend}
		"$this_function"_{$blend_mode} {$argv}
	end
end
