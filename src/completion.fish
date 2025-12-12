function providing-blend-value
	test "$(commandline --current-process --current-token)" = '--blend='
end

begin # Directories
set --local directories '(__fish_complete_directories)'
	complete --command='symp' --no-files --arguments={$directories}
end



complete --command='symp' --short-option='h' --long-option='help' 		--description='Print help'
complete --command='symp' --short-option='v' --long-option='verbose'	 	--description='Show more information'


complete --command='symp' --no-files --short-option='b' 	--long-option='blend' 						--description='Inherit access of the new parent'
complete --command='symp' --no-files --short-option='b' 	--long-option='blend' 		--arguments='ownership'		--description='User & Group' 				--condition='providing-blend-value'
complete --command='symp' --no-files --short-option='b' 	--long-option='blend' 		--arguments='permission'	--description='Discretionary Access Control' 		--condition='providing-blend-value'

complete --command='symp' --exclusive --short-option='o' 	--long-option='occurrence' 	--arguments='common' 		--description='Present in the target'
complete --command='symp' --exclusive --short-option='o' 	--long-option='occurrence' 	--arguments='unique' 		--description='Absent in the target (avoid overwrites)'
complete --command='symp' --exclusive --short-option='o' 	--long-option='occurrence' 					--description='Filter files based on their occurrences'

complete --command='symp' --exclusive --short-option='r' 	--long-option='resolution' 	--arguments='absolute' 		--description='Point symlinks to absolute path'
complete --command='symp' --exclusive --short-option='r' 	--long-option='resolution' 	--arguments='relative' 		--description='Point symlinks to relative path'
complete --command='symp' --exclusive --short-option='r' 	--long-option='resolution' 					--description='Configure symlink resolution'

complete --command='symp' --exclusive --short-option='O' 	--long-option='overwrites' 	--arguments='backup'	 	--description='Backup before overwriting'
complete --command='symp' --exclusive --short-option='O' 	--long-option='overwrites' 	--arguments='interactive' 	--description='Confirm interactively'
complete --command='symp' --exclusive --short-option='O' 	--long-option='overwrites' 	--arguments='force'		--description='No confirmation'
complete --command='symp' --exclusive --short-option='O' 	--long-option='overwrites' 					--description='Change behavior for overwrites' 
