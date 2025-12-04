function _symp_common_exit-on-error --description='Exit the script on error to prevent further mis-execution'
	set --local last_status {$status}
	if test {$last_status} -ne 0
		exit {$last_status}
	end
end
