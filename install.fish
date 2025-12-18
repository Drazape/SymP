#!/usr/bin/env fish
set --global official_git_repository_url 'https://github.com/Dracape/SymP'
set --global official_git_repository_name (string split --fields=5 '/' {$official_git_repository_url})
set --global executable_name (string lower {$official_git_repository_name})



# Handle external configuration
## Arguments
### Switches
argparse 'r/repository=&' 'h/help&' 'v/verbose&' 's/symlink&' -- {$argv}
test "$status" -ne 0 && return 1
set --erase --local _flag_{r,h,v,s} # Unused, short name flags

### Positional
if test (count {$argv}) -ne 0
	echo (status basename)': Positional arguments are not supported'
	return 1
else
	set --erase --local argv
end

### Individual
## Verbose
if set -ql _flag_verbose || set -qlx VERBOSE
	set --global --export VERBOSE '--verbose'
	set --erase --local _flag_verbose
end

#### Help
if set -ql _flag_help
	echo -e 'Install \e]8;;'{$official_git_repository_url}'\a'{$official_git_repository_name}'\e]8;;\a' # Description with hyper-link
	set_color --bold --underline; echo -n \n'Usage:'; set_color normal; echo ' '(status basename)' [OPTION]'
	set_color --bold --underline; echo \n'Options:'

	set_color --bold normal; echo -n -- '  -h'; set_color normal; echo -n ', '; set_color --bold; echo -- '--help'
	set_color normal; echo \t'Print help'

	set_color --bold; echo -n -- '  -v'; set_color normal; echo -n ', '; set_color --bold; echo -- '--verbose'
	set_color normal; echo \t'Show more information'
	echo -n \t'(Variable: '; set_color --italics; echo -n 'VERBOSE'; set_color normal; echo \)

	set_color --bold; echo -n -- '  -r'; set_color normal; echo -n ', '; set_color --bold; echo -- '--repository'
	set_color normal; echo \t'Specify source-code repository path (local or remote git)'
	echo -n \t'(Variable: '; set_color --italics; echo -n 'REPOSITORY'; set_color normal; echo \)

	set_color --bold; echo -n -- '  -s'; set_color normal; echo -n ', '; set_color --bold; echo -- '--symlink'
	set_color normal; echo \t'Symlink files from git-repository instead of copying'

	if set -qgx VERBOSE
		set_color --bold --underline; echo \n'Variables:'
		set_color --bold normal; echo '  VERBOSE'
		set_color normal; echo \t'Show more information'
		echo -n \t'(Switch: '; set_color --italics; echo -n -- '-v'; set_color normal; echo -n ', '; set_color --italics; echo -n -- '--verbose'; set_color normal; echo \)

		set_color --bold; echo '  REPOSITORY'
		set_color normal; echo \t'Specify source-code repository path (local or remote git)'
		echo -n \t'(Switch: '; set_color --italics; echo -n -- '-r'; set_color normal; echo -n ', '; set_color --italics; echo -n -- '--repository'; set_color normal; echo \)
	end
	return 0
end



# Only allow execution as root
if ! fish_is_root_user
	echo (status basename)': Must be ran as root'
	return  1
end



# Verify dependencies
begin
	set --local coreutils ls rm ln chmod chown
	for command in {$coreutils} 'fd'
		if ! type --query {$command}
			contains {$command} {$coreutils} && set --function mention_if_core 'coreutils: '
			echo (status basename)': Missing command: '"$mention_if_core"{$command} 1>&2
			return 1
		end
	end
end


# Set source-code directory path
## Overwrite REPOSITORY environment variable if the equivalent switch is provided
if set -ql _flag_repository
	set --function REPOSITORY {$_flag_repository}
	set --erase --local _flag_repository # Remove the flags as already set as REPOSITORY
end

## Setup Cleanup
function cleanup_temporary_repository --description='Nuke temporary repository on exit' --on-event=fish_exit
	set -qg tmp_repo && rm -rf {$repository_dir}
end

## Parse repository switch/variable
if set -q REPOSITORY
	if path is --type=dir {$REPOSITORY}/src # Set repository as local if the source code directory in the specified path exists
		set -q VERBOSE && echo 'Repository found locally: '{$REPOSITORY}
		set --global source_code_dir {$REPOSITORY}/src
	else
		if ! string match --regex -- 'https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()!@:%_\\+.~#?&\\/\\/=]*)' {$REPOSITORY}
			echo -- (status basename)': Invalid path' 1>&2
			return 1
		end

		set -ql _flag_symlink && echo 'Cannot symlink from a temporary directory' >&2
		set --global repository_dir (mktemp --directory /tmp/"$(string split '/' "$REPOSITORY" | tail -n 1)"-'XXXXXXXXX')
		set --global tmp_repo

		git clone --filter=blob:none "$REPOSITORY" "$repository_dir"
		test {$status} -ne 0 && return 1

		set --erase --function REPOSITORY
		set --global source_code_dir {$repository_dir}/src
	end
end

## Fallback
if ! path is --type=dir {$source_code_dir}
	if path is --type=dir ./src/
		set --global source_code_dir {$PWD}/src
	else # Official remote
		set --global repository_dir (mktemp --directory /tmp/"$official_git_repository_name"-XXXXXXXXXX)
		set --global tmp_repo
		git clone --filter=blob:none "$official_git_repository_url"'.git' {$repository_dir}
		set --global source_code_dir {$repository_dir}/src
	end
end



# Install to local-vendor directory
set -q VERBOSE && echo (status basename)': Operating in '{$source_code_dir}
cd {$source_code_dir}


## Operate
set --local local_vendor_functions_dir /usr/local/share/fish/vendor_functions.d
### Functions' path for root
begin
	set --local global_fish_config_path /etc/fish/conf.d/local-functions.fish

	# Preparation
	mkdir -p (path dirname {$global_fish_config_path})
	touch {$global_fish_config_path}

	# Main file
	echo 'if ! contains '"$local_vendor_functions_dir"' {$fish_function_path}
'\t'set --prepend fish_function_path '"$local_vendor_functions_dir"'
end' | tee {$global_fish_config_path} > /dev/null 
end


### Source code
#### Main executable
begin
	set --local executable_install_path /usr/local/bin/{$executable_name}

	rm --force {$executable_install_path} # Remove if already exists
	if set -ql _flag_symlink
		mkdir -p (path dirname {$executable_install_path})
		ln -s --relative {$VERBOSE} -- (realpath --no-symlinks ./main.fish) {$executable_install_path}
		chmod +x {$executable_install_path}
	else
		install -D {$VERBOSE} -- ./main.fish {$executable_install_path} # Install main executable script
	end
end

#### Libraries
fd --regex '^_symp_\w*' {$local_vendor_functions_dir} --exec-batch rm --force 

set --local libraries (fd --base-directory=./lib/ --type=file --extension=fish)
set --local absolute_library_names (string replace --all '/main' \0 {$libraries} | string replace --all '/' '_')

for i in (seq (count {$libraries}))
	set --local install_path {$local_vendor_functions_dir}/_{$executable_name}_{$absolute_library_names[$i]} 
	if set -ql _flag_symlink
		mkdir -p {$local_vendor_functions_dir}
		ln -s --relative {$VERBOSE} (realpath --no-symlinks lib/"$libraries[$i]") {$install_path}
	else
		install -D --mode=644 {$VERBOSE} lib/"$libraries[$i]" {$install_path}
	end
end

#### Completion
begin
	set --local local_vendor_completions_dir /usr/local/share/fish/vendor_completions.d
	set --local completion_install_path "$local_vendor_completions_dir"/"$executable_name".fish
	rm --force {$completion_install_path}

	if set -ql _flag_symlink
		mkdir -p {$local_vendor_completions_dir}
		ln -s --relative {$VERBOSE} (realpath --no-symlinks ./completion.fish) "$completion_install_path"
	else
		install -D --mode=644 {$VERBOSE} ./completion.fish "$completion_install_path"
	end	
end

# Clone wiki on standard installation
set -ql _flag_symlink || git clone https://github.com/Dracape/SymP.wiki.git /usr/local/share/doc/SymP
