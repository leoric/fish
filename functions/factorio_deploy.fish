function factorio_deploy --description 'Zip the mod in $PWD, move it to MEGA, symlink it into Factorio mods'
    # try/always replacement: do the work in a helper, then always clean up
    set -l start_dir $PWD
    set -l tmp_dir /tmp/factorio_build_$fish_pid

    _factorio_deploy_steps $tmp_dir
    set -l rc $status

    test -d $tmp_dir; and rm -rf $tmp_dir
    cd $start_dir
    return $rc
end
