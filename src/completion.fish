complete --command='symp' --short-option='h' --long-option='help' 		--description='Print help'
complete --command='symp' --short-option='v' --long-option='verbose'	 	--description='Show more information'
complete --command='symp' --short-option='B' --long-option='blend' 		--description='Inherit permissions of the new parent'


complete --command='symp' --exclusive --short-option='b' --long-option='behaviour' --arguments='interactive' 	--description='Confirm overwrites interactively'
complete --command='symp' --exclusive --short-option='b' --long-option='behaviour' --arguments='force' 		--description='Overwrite files'
complete --command='symp' --exclusive --short-option='b' --long-option='behaviour' 				--description='Change behaviour for overwrites' 

complete --command='symp' --exclusive --short-option='o' --long-option='occurrence' --arguments='common' 	--description='Present in the target'
complete --command='symp' --exclusive --short-option='o' --long-option='occurrence' --arguments='unique' 	--description='Absent in the target (avoid overwrites)'
complete --command='symp' --exclusive --short-option='o' --long-option='occurrence' 				--description='Filter files based on their occurrences'
