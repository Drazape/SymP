function _symp_operate_case_recursive_children_recurse --description='Re-operate on a new set of directories'
    _"$program_name"_common_set-output-prefix (status current-function)

    set -qg SYMP_VERBOSE && echo {$output_prefix} 'Recursing:'\t'Source: '(set_color --bold){$argv[1]}(set_color normal)' target: '(set_color --bold){$argv[2]}(set_color normal) # Verbosity announcement

    # Main
    source_dir={$argv[1]} target_path={$argv[2]} "$operate_function"
end
