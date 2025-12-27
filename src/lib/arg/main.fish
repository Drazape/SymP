function _symp_arg --description='Parse arguments'
	set --local this_function (status current-function)
	"$this_function"_count --allow=2 -- {$argv}
	"$this_function"_define {$argv}
end
