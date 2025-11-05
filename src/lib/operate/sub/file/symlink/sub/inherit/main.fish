function _symp_operate_file_symlink_inherit --description='Inherit properties of the new parent directory'
	set --append --local --export OUTPUT_PREFIX (status current-function | string split '_' | tail -n 1)':' # Append the Output-prefix with the current function name
	set --local this_function (status current-function)	

	"$this_function"_ownership {$argv}
	"$this_function"_permissions {$argv}
end
