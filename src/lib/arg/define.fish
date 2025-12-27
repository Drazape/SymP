function _symp_arg_define --description='Define the path values'
	set --global -- source_dir (path normalize -- {$argv[1]})
	set --global -- target_path (path normalize -- {$argv[2]})
end
