complete --command='symp' --short-option='h' --long-option='help' 		--description='Print help'
complete --command='symp' --short-option='v' --long-option='verbose'	 	--description='Show more information'
complete --command='symp' --short-option='B' --long-option='blend' 		--description='Inherit permissions of the new parent'
complete --command='symp' --short-option='c' --long-option='common-only' 	--description='Only symlink common files'

complete --command='symp' --exclusive --short-option='b' --long-option='behaviour' --arguments 'interactive force' --description='Change behaviour for overwrites'
