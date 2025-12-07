function _symp_operate_file_symlink_inherit_ownership --description='Inherit ownership of the new parent directory'
	set --local -- source_file {$argv[1]}
	set --local -- target_parent {$argv[2]}

	set --query SYMP_VERBOSE && echo {$output_prefix} 'Setting ownership of Source '\"(set_color --bold){$source_file}(set_color normal)\"' to that of the new parent' # Verbosity announcement

	set --local parent_ownership (stat -c %u:%g {$target_parent})
	chown -R -- {$parent_ownership} {$source_file}
end
