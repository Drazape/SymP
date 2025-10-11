#!/usr/bin/env fish
set --global official_git_repository_url 'https://github.com/Dracape/SymP'
set --global official_git_repository_name (string split --fields=5 '/' {$official_git_repository_url})

# Handle external configuration
## Arguments
### Switches
argparse 'r/repository=&' 'h/help&' 'v/verbose&' -- {$argv}
### Positional
if test (count {$argv}) -ne 0
	echo (status basename)': Positional arguments are not supported'
	exit 1
else
	set --erase --local argv
end

### Individual
## Verbose
if set -ql _flag_verbose || set -qlx VERBOSE
	set --global --export VERBOSE '--verbose'
	set --erase --local _flag_verbose _flag_v
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



function sudo-on-fail --description 'Retry command with sudo if failed the first time'
	if ! {$argv}
		echo -n 'Retrying with '; set_color --italics; echo 'sudo'
		sudo {$argv}
	end
end



# Verify dependencies
begin
	set --local coreutils ls rm ln chmod chown
	for command in {$coreutils} 'fd'
		if ! type --query {$command}
			if contains {$command} {$coreutils}
				set --function mention_if_core 'coreutils: '
			end
			echo (status basename)': Missing command: '"$mention_if_core"{$command} 1>&2
			if type --query pacman
				if set -qf mention_if_core
					sudo-on-fail pacman -Syu --needed coreutils
				else
					sudo-on-fail pacman -Syu --needed fd 
				end
			else
				exit 1
			end
		end
	end
end


# Set source-code directory path
## Overwrite REPOSITORY environment variable if the equivalent switch is provided
if set -ql _flag_repository
	set --function REPOSITORY {$_flag_repository}
	set --erase --local _flag_r{epository,} # Remove the flags as already set as REPOSITORY
end

## Parse repository switch/variable
if set -q REPOSITORY
	if path is -d {$REPOSITORY}/src # Set repository as local if the source code directory in the specified path exists
		if set -q VERBOSE
			echo 'Repository found locally: '{$REPOSITORY}
		end
		set --global source_code_dir {$REPOSITORY}/src
	else
		if ! string match --regex -- 'https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()!@:%_\\+.~#?&\\/\\/=]*)' {$REPOSITORY}
			echo -- (status basename)': Invalid URL' 1>&2
			return 1
		end

		set --global repository_dir (mktemp --directory /tmp/"$(string split '/' "$REPOSITORY" | tail -n 1)"-'XXXXXXXXX')
		set --global tmp_repo

		sudo-on-fail git clone "$REPOSITORY" "$repository_dir"
		if test {$status} -ne 0
			exit 1
		end

		set --erase --function REPOSITORY
		set --global source_code_dir {$repository_dir}/src
	end
end

## Fallback
if ! path is -d {$source_code_dir}
	if path is -d {$PWD}/src # Local
		set --global source_code_dir {$PWD}/src
	else # Official remote
		set --global repository_dir (mktemp --directory /tmp/"$official_git_repository_name"-XXXXXXXXXX)
		set --global tmp_repo
		sudo-on-fail git clone "$official_git_repository_url"'.git' {$repository_dir}
		set --global source_code_dir {$repository_dir}/src
	end
end



# Install to local-vendor directory
if set -q VERBOSE # Verbosity announcement
	echo (status basename)': Operating in '{$source_code_dir}
end
cd {$source_code_dir}


## Operate
set --local local_vendor_functions_dir /usr/local/share/fish/vendor_functions.d
### Functions' path for root
begin
	set --local local_functions_config_path /root/.local/share/fish/vendor_functions.d/local-functions.fish

	# Preparation
	mkdir -p (path dirname {$local_functions_config_path})
	touch {$local_functions_config_path}

	# Main file
	echo 'if ! contains '"$local_vendor_functions_dir[1]"' {$fish_function_path}
'\t'set --prepend fish_function_path
end' | sudo tee {$local_functions_config_path} > /dev/null 
end


### Source code
#### Main executable
begin
	set --local executable_install_path /usr/local/bin/{$official_git_repository_name}

	sudo-on-fail cp {$VERBOSE} ./main.fish {$executable_install_path} # Install main executable script
	sudo-on-fail chmod +x {$executable_install_path}
end

#### Libraries
sudo-on-fail mkdir -p {$VERBOSE} {$local_vendor_functions_dir[1]}

set --local libraries (fd --base-directory=./lib/ --type=file --extension=fish)
set --local absolute_library_names (string replace --all '/' '_' {$libraries} | string replace --all '_sub' \0 | string replace --all '_main' \0)

for i in (seq (count {$libraries}))
	sudo-on-fail cp {$VERBOSE} lib/"$libraries[$i]" {$local_vendor_functions_dir[1]}/_{$official_git_repository_name}_{$absolute_library_names[$i]}
end

#### Completion
begin
	set --local local_vendor_completions_dir /usr/local/share/fish/vendor_completions.d
	sudo-on-fail mkdir -p {$local_vendor_completions_dir}
	sudo-on-fail cp {$VERBOSE} ./completion.fish "$local_vendor_completions_dir"/"$official_git_repository_name".fish
end

# Cleanup
if set -qg tmp_repo
	sudo-on-fail rm -rf {$repository_dir}
end
