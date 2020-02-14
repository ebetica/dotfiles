source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug 'delapouite/kakoune-livedown' %{
    set-option global livedown_browser 'firefox --new-window'
}

plug "andreyorst/fzf.kak" defer "fzf" %{
    set-option global fzf_file_command 'fd'
    map global user e %{
        :echo -debug %opt{fzf_file_command}<ret>
        :fzf-mode<ret>f
        :set-option global fzf_file_command 'fd --type f --follow . $(dirname $kak_bufname)'<ret>
    }
}

plug "andreyorst/smarttab.kak" defer smarttab %{
    set-option global tabstop 4
    set-option global softtabstop 4
} config %{
    hook global WinSetOption filetype=(makefile|gas) noexpandtab
    hook global WinSetOption filetype=(rust|markdown|kak|c|cpp|python) expandtab
}

eval %sh{kak-lsp --kakoune -s $kak_session}
# nop %sh{ (kak-lsp -s $kak_session -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }
lsp-enable

map global normal = ':format<ret>'
map global normal * <a-i>w*
map global insert <c-w> '<a-;>:exec -draft hbd<ret>'

map global user f ':fzf-mode<ret>'
map global user a ':alt<ret>'
map global user , ':lsp-hover<ret>'
map global normal D ':lsp-find-error<ret>l:lsp-hover<ret>'
map global normal \' \;
map global normal <semicolon> \;

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
hook global WinSetOption filetype=python %{ set window formatcmd 'black -' }

add-highlighter global/ number-lines -relative
face global MenuBackground default,black

set global scrolloff 10,10
