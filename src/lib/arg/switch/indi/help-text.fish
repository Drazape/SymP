function _symp_arg_switch_indi_help-text --description='Help text for the `--help` switch of SymP'
	set_color magenta; echo 'Populate '(set_color --italics)'TARGET'(set_color normal)(set_color magenta)' with the least amount of symbolic links as possible from '(set_color --italics)'SOURCE_DIR.'\n; set_color normal
	begin
		set --local page 'Usage'
		set --local wiki_page 'https://github.com/Dracape/SymP/wiki'/{$page}
		set_color blue --bold --underline; echo -ne '\e]8;;'{$wiki_page}'\a'{$page}'\e]8;;\a:'; set_color normal; echo ' '"$program_name"' '(set_color cyan)'[OPTION]'(set_color normal)' SOURCE_DIR TARGET'\n
	end
	set_color blue --bold --underline; echo 'Arguments:'; set_color normal; echo \t'<paths>…'\n


	set_color blue --bold --underline; echo 'Options:'
	set_color normal; echo -n '  '(set_color --bold green)'-h'; set_color normal; echo -n ', '; set_color --bold green; echo -n -- '--help'
	set_color normal; echo \t\t\t\t\t\t\t'Print help'
	
	set_color normal; echo -n '  '; set_color --bold green; echo -n -- '-v'; set_color normal; echo -n ', '; set_color --bold green; echo -n -- '--verbose'
	set_color normal; echo \t\t\t\t\t\t\t'Show more information'
	echo -n \t'('(set_color yellow)'Environment'(set_color normal)': '; set_color green --italics; echo -n 'SYMP_VERBOSE VERBOSE'; set_color normal --dim; echo '='(set_color normal)')'
	
	set_color normal; echo -n '  '; set_color --bold green; echo -n -- '-b'; set_color normal; echo -n ', '; set_color --bold green; echo -n -- '--blend'\t'-b'; set_color normal; echo -n '['; set_color --bold brgreen; echo -n 'o'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'p'; set_color normal; echo -n '], '; set_color --bold green; echo -n -- '--blend'; set_color normal --dim; echo -n '='(set_color normal)'['; set_color --bold brgreen; echo -n 'ownership'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'permission'; set_color normal; echo -n ']'
	set_color normal; echo \t\t'Inherit access attributes of the new parent'
	
	set_color normal; echo -n '  '; set_color --bold green; echo -n -- '-o'; set_color normal; echo -n ' ['; set_color --bold brgreen; echo -n 'c'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'u'; set_color normal; echo -n '], '; set_color --bold green; echo -n -- '--occurrence'; set_color normal; echo -n ' ['; set_color --bold brgreen; echo -n 'common'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'unique'; set_color normal; echo -n ']'
	set_color normal; echo \t\t\t'Filter files based on their occurrences'

	set_color normal; echo -n '  '; set_color --bold green; echo -n -- '-r'; set_color normal; echo -n ' ['; set_color --bold brgreen; echo -n 'a'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'r'; set_color normal; echo -n '], '; set_color --bold green; echo -n -- '--resolution'; set_color normal; echo -n ' ['; set_color --bold brgreen; echo -n 'absolute'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'relative';set_color normal; set_color white --dim; echo -n ' ('(set_color normal)(set_color red)'default'(set_color white --dim)')'(set_color normal)']'
	echo \t\t'Configure symlink resolution'

	set_color normal; echo -n '  '; set_color --bold green; echo -n -- '-O'; set_color normal; echo -n ' ['; set_color --bold brgreen; echo -n 'i'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'f'; set_color normal; echo -n '], '; set_color --bold green; echo -n -- '--overwrites'; set_color normal; echo -n ' ['; set_color --bold brgreen;echo -n 'backup'; set_color normal --dim; echo -n '|'; set_color normal;set_color --bold brgreen ; echo -n 'interactive'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'force'; set_color normal; set_color white --dim; echo -n ' ('(set_color normal)(set_color red)'default'(set_color white --dim)')'(set_color normal)']'
	echo \t'Change overwrite behavior'
	echo \t'('(set_color yellow)'Environment'(set_color normal)': '(set_color --italics green)'SYMP_INTERACTIVE INTERACTIVE'(set_color normal --dim)'='(set_color normal)\)



	if set -qg SYMP_VERBOSE
		set_color blue --bold --underline; echo \n'Variables:'
		set_color normal; echo -n '  '(set_color --bold green)'SYMP_VERBOSE'; set_color normal; echo -n ', '; set_color --bold green; echo -n 'VERBOSE'; set_color normal --dim; echo -n '='(set_color normal)'['; set_color --bold brgreen; echo -n '1'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'true'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'yes'; set_color normal; echo -n ']' 
		echo \t\t\t\t'Show more information'
		set_color normal; echo -n \t'('(set_color yellow)'Switch'(set_color normal)': '; set_color --italics green; echo -n -- '-v';set_color normal; echo -n ', ';set_color --italics green ; echo -n -- '--verbose' ; set_color normal; echo \)
	
		set_color normal; echo -n '  '(set_color --bold green)'SYMP_INTERACTIVE'; set_color normal; echo -n ', '; set_color --bold green; echo -n 'INTERACTIVE'; set_color normal --dim; echo -n '='(set_color normal)'['; set_color --bold brgreen; echo -n '1'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'true'; set_color normal --dim; echo -n '|'; set_color normal; set_color --bold brgreen; echo -n 'yes'; set_color normal; echo -n ']'
		set_color normal; echo \t\t\t'Confirm overwrites interactively'
		echo \t'('(set_color yellow)'Switch'(set_color normal)': --['(set_color --italics green)'O'(set_color --dim normal)'|'(set_color normal)(set_color --italics green)'overwrites'(set_color normal)'] ['(set_color --italics brgreen)'i'(set_color --dim normal)'|'(set_color normal)(set_color --italics brgreen)'interactive'(set_color normal)'])' 
	end
end
