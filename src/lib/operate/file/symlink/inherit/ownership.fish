function _symp_operate_file_symlink_inherit_ownership --description='Inherit ownership of the new parent directory'
	set --local -- source_file {$argv[1]}
	set --local -- target_parent {$argv[2]}

	if set --query SYMP_VERBOSE
		echo (set_color --dim){$output_prefix}(set_color normal) 'Setting ownership of Source '\"{$source_file}\"' to that of the new parent'
	end

	set --local parent_ownership (stat -c %u:%g {$target_parent})
	chown -R -- {$parent_ownership} {$source_file}
end
