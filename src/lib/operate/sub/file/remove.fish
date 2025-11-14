function _symp_operate_file_remove --description 'Simple `rm` wrapper with customizations'
	if test {$overwrites} != '--backup'
		rm {$SYMP_VERBOSE} {$overwrites} {$argv}
	end
end
