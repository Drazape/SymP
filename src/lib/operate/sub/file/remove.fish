function _symp_operate_file_remove --description 'Simple `rm` wrapper with customizations'
	rm {$SYMP_VERBOSE} {$overwrites} {$argv}
end
