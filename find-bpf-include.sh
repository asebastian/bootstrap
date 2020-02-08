#!/bin/bash
find / -type d -exec bash -O dotglob -c '
    for dirpath do
        ok=true
        seen_files=false
        set -- "$dirpath"/*
        for name do
            [ -d "$name" ] && continue  # skip dirs
            seen_files=true
            case "${name##*/}" in
                bpf.h|btf.h|libbpf.h) ;; # do nothing
                *) ok=false; break
            esac
        done

        "$seen_files" && "$ok" && printf "%s\n" "$dirpath"
    done' bash {} +
