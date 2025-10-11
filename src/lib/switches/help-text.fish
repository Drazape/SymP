function _symp_switches_help-text
	echo 'Smartly symlink SOURCE_DIR to TARGET.'\n
	set_color --bold --underline; echo -n 'Usage:'; set_color normal; echo ' '"$script_name"' [OPTION] SOURCE_DIR TARGET'\n
	set_color --bold --underline; echo 'Arguments:'; set_color normal; echo \t'<paths>…'\n

	set_color --bold --underline; echo 'Options:'
	set_color --bold normal; echo -n -- '  -h'; set_color normal; echo -n ', '; set_color --bold; echo -- '--help'
	set_color normal; echo \t'Print help'
	set_color --bold; echo -n -- '  -v'; set_color normal; echo -n ', '; set_color --bold; echo -- '--verbose'
	set_color normal; echo -n \t'Show more information'\n\t'(Variable: '; set_color --italics; echo -n 'VERBOSE'; set_color normal; echo \)
	set_color --bold; echo -n -- '  --[b|behaviour]=[i|interactive]'; set_color normal; echo -n -- ', '; set_color --bold; echo -n -- '--[b|behaviour]=[f|force]'; set_color normal; echo ' (default)'
	echo \t'Change behaviour for overwrites'
	echo -n \t'(Environment: '; set_color --italics; echo -n 'INTERACTIVE'; set_color normal; echo ')'
	set_color --bold; echo -n -- '  -c'; set_color normal; echo -n ', '; set_color --bold; echo -- '--common-only'
	set_color normal; echo \t'Only symlink common files'

	if set -q VERBOSE
		set_color --bold --underline; echo \n'Variables:'
		set_color --bold normal; echo '  VERBOSE'
		set_color normal; echo \t'Show more information'
		set_color normal; echo -n \t'(Switch: '; set_color --italics; echo -n -- '-v';set_color normal; echo -n ', ';set_color --italics ; echo -n -- '--verbose' ; set_color normal; echo \)
	
		set_color --bold normal; echo '  OUTPUT_PREFIX'
		set_color normal; echo \t'Change default output stream prefix'

		set_color --bold normal; echo '  INTERACTIVE'
		set_color normal; echo \t'Confirm overwrites interactively'
		echo -n \t'(Switch: '; set_color --italics; echo -n -- '--[b|behaviour]=[i|interactive]'; set_color normal; echo \) 
	end
end
