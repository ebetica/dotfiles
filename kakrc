source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug 'delapouite/kakoune-livedown' %{
   set-option global livedown_browser 'firefox --new-window'
}

plug "andreyorst/fzf.kak" config %{
    require-module fzf
    map global user e %{
        :fzf -kak-cmd %{edit -existing} -preview -items-cmd "fd --type f -L . $(dirname %val{bufname})"<ret>
    }
} defer fzf %{
    set-option global fzf_file_command 'fd'
}

plug "andreyorst/smarttab.kak" defer smarttab %{
    set-option global tabstop 4
    set-option global softtabstop 4
} config %{
    hook global WinSetOption filetype=(makefile|gas) noexpandtab
    hook global WinSetOption filetype=(rust|markdown|kak|c|cpp|python) expandtab
    hook global WinSetOption filetype=(yaml|json) %{ set-option window tabstop 2 }
    hook global WinSetOption filetype=(yaml|json) %{ set-option window softtabstop 2 }
}

eval %sh{kak-lsp --kakoune -s $kak_session}
# set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"
lsp-enable

plug "h-youhei/kakoune-surround"
declare-user-mode surround
map global surround s ':surround<ret>' -docstring 'surround'
map global surround c ':change-surround<ret>' -docstring 'change'
map global surround d ':delete-surround<ret>' -docstring 'delete'
map global surround t ':select-surrounding-tag<ret>' -docstring 'select tag'
map global normal '<c-r>' ':enter-user-mode surround<ret>'

map global normal = ':format<ret>'
map global normal * <a-i>w*
map global insert <c-w> '<a-;>:exec -draft hbd<ret>'

map global user f ':fzf-mode<ret>'
map global user a ':alt<ret>'
map global user , ':lsp-hover<ret>'
map global normal D ':lsp-find-error<ret>l:lsp-hover<ret>'
map global normal \' \;
map global normal <semicolon> :

hook global WinCreate .* %{ addhl window/ show-matching }

hook global InsertCompletionShow .* %{
    try %{
        # this command temporarily removes cursors preceded by whitespace;
        # if there are no cursors left, it raises an error, does not
        # continue to execute the mapping commands, and the error is eaten
        # by the `try` command so no warning appears.
        execute-keys -draft 'h<a-K>\h<ret>'
        map window insert <tab> <c-n>
        map window insert <s-tab> <c-p>
    }
}
hook global InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <s-tab> <c-p>
}

hook global WinSetOption filetype=cpp %{ set window formatcmd 'clang-format-7 -assume-filename ${kak_buffile}' }
hook global WinSetOption filetype=python %{
    set window formatcmd 'isort --profile=black - | black -'
    # hacky-workaround to get linefeeds into paste buffers
    # Credit to @cole-h
    execute-keys ':set-register p "        __import__(''ipdb'').set_trace()<c-v><ret>"<ret>'
}

add-highlighter global/ number-lines -relative
face global MenuBackground default,black

set global scrolloff 10,10

