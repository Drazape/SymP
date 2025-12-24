#!/usr/bin/env fish
set --global official_git_repository_url 'https://github.com/Dracape/SymP'
set --global official_git_repository_name (string split --fields=5 '/' {$official_git_repository_url})
set --global executable_name (string lower {$official_git_repository_name})



# Handle external configuration
## Arguments
### Switches
argparse 'r/repository=&' 'R/rootdir=&!path is --type=dir {$_flag_value}' 'v/verbose&' 'V/vendor&' 's/symlink&' -- {$argv}
test "$status" -ne 0 && return 1
set --erase --local _flag_{R,r,v,V,s} # Unused, short name flags

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

#### Vendor
set -ql _flag_vendor || set local_dir '/local'



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
	set -qg tmp_repo && rm -rf -- {$repository_dir}
end

## Parse repository switch/variable
if set -q REPOSITORY
	if path is --type=dir -- {$REPOSITORY}/src # Set repository as local if the source code directory in the specified path exists
		set -q VERBOSE && echo 'Repository found locally: '{$REPOSITORY}
		set --global -- source_code_dir {$REPOSITORY}/src
	else
		if ! string match --regex -- 'https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()!@:%_\\+.~#?&\\/\\/=]*)' {$REPOSITORY}
			echo -- (status basename)': Invalid path' 1>&2
			return 1
		end

		set -ql _flag_symlink && echo 'Cannot symlink from a temporary directory' >&2
		set --global -- repository_dir (mktemp --directory /tmp/"$(string split '/' "$REPOSITORY" | tail -n 1)"-'XXXXXXXXX')
		set --global tmp_repo

		git clone --filter=blob:none "$REPOSITORY" "$repository_dir"
		test {$status} -ne 0 && return 1

		set --erase --function REPOSITORY
		set --global -- source_code_dir {$repository_dir}/src
	end
end

## Fallback
if ! path is --type=dir -- {$source_code_dir}
	if path is --type=dir ./src/
		set --global -- source_code_dir {$PWD}/src
	else if path is --type=dir (path dirname -- (status current-filename))/src
		set --global -- source_code_dir (path dirname -- (status current-filename))/src
	else # Official remote
		set --global -- repository_dir (mktemp --directory /tmp/"$official_git_repository_name"-XXXXXXXXXX)
		set --global tmp_repo
		git clone --filter=blob:none "$official_git_repository_url"'.git' {$repository_dir}
		set --global -- source_code_dir {$repository_dir}/src
	end
end



# Install to local-vendor directory
set -q VERBOSE && echo (status basename)': Operating in '{$source_code_dir}
cd {$source_code_dir}


## Operate
set --local local_vendor_functions_dir "$_flag_rootdir"/usr"$local_dir"/share/fish/vendor_functions.d
### Functions' path for root
if ! set -ql _flag_vendor
	set --local global_fish_config_path /etc/fish/conf.d/local-functions.fish

	# Preparation
	mkdir -p -- (path dirname {$global_fish_config_path})
	touch -- {$global_fish_config_path}

	# Main file
	echo 'if ! contains '"$local_vendor_functions_dir"' {$fish_function_path}
'\t'set --prepend fish_function_path '"$local_vendor_functions_dir"'
end' | tee {$global_fish_config_path} > /dev/null 
end


### Source code
#### Main executable
begin
	set --local executable_install_path "$_flag_rootdir"/usr"$local_dir"/bin/{$executable_name}

	rm --force -- {$executable_install_path} # Remove if already exists
	if set -ql _flag_symlink
		mkdir -p (path dirname {$executable_install_path})
		ln -s --relative {$VERBOSE} -- (realpath --no-symlinks ./main.fish) {$executable_install_path}
		chmod -- +x {$executable_install_path}
	else
		install -D {$VERBOSE} -- ./main.fish {$executable_install_path} # Install main executable script
	end
end

#### Libraries
set -ql _flag_vendor || fd --regex '^_symp_\w*' {$local_vendor_functions_dir} --exec-batch rm --force 

set --local -- libraries (fd --base-directory=./lib/ --type=file --extension=fish)
set --local -- absolute_library_names (string replace --all '/main' \0 {$libraries} | string replace --all '/' '_')

for i in (seq (count {$libraries}))
	set --local -- install_path {$local_vendor_functions_dir}/_{$executable_name}_{$absolute_library_names[$i]} 
	if set -ql _flag_symlink
		mkdir -p -- {$local_vendor_functions_dir}
		ln -s --relative {$VERBOSE} -- (realpath --no-symlinks lib/"$libraries[$i]") {$install_path}
	else
		install -D --mode=644 {$VERBOSE} -- lib/"$libraries[$i]" {$install_path}
	end
end

#### Completion
begin
	set --local local_vendor_completions_dir "$_flag_rootdir"/usr"$local_dir"/share/fish/vendor_completions.d
	set --local -- completion_install_path "$local_vendor_completions_dir"/"$executable_name".fish
	rm --force -- {$completion_install_path}

	if set -ql _flag_symlink
		mkdir -p -- {$local_vendor_completions_dir}
		ln -s --relative {$VERBOSE} -- (realpath --no-symlinks ./completion.fish) "$completion_install_path"
	else
		install -D --mode=644 {$VERBOSE} -- ./completion.fish "$completion_install_path"
	end	
end

# Clone wiki on standard installation
if set -ql _flag_symlink
	set --local doc_path "$_flag_rootdir"/usr"$local_dir"/share/doc/SymP

	if ! path is --type=dir {$doc_path}
		git clone --filter=blob:none https://github.com/Dracape/SymP.wiki.git -- {$doc_path}
	else
		cd {$doc_path}
		git pull
	end
	install -D --mode=644 {$VERBOSE} -- ../README.md {$doc_path}
end

# Add license on vendor installation
set -ql _flag_vendor && install -D --mode=644 {$VERBOSE} -- ../LICENSE /usr/share/licenses/{$executable_name}/LICENSE
