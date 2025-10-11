complete --command='smart-symlink' 	--short-option='h' --long-option='help' \
					--short-option='v' --long-option='verbose' \
					--short-option='B' --long-option='blend' \
					--short-option='c' --long-option='common-only'

complete --command='smart-symlink' --exclusive --short-option='b' --long-option='behaviour' --arguments 'interactive force'
