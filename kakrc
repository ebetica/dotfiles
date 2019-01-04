source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug "andreyorst/fzf.kak"
set-option global fzf_file_command 'fd'

map global user e %{
    :evaluate-commands %sh{ echo "set-option global fzf_file_command 'fd --type f --follow . $(dirname $kak_bufname)'" }<ret>
    :echo -debug %opt{fzf_file_command}<ret>
    :fzf-mode<ret>f
    :set-option global fzf_file_command 'fd'<ret>
}

eval %sh{kak-lsp --kakoune -s $kak_session}
lsp-enable
lsp-auto-hover-enable

set global ycmd_path /private/home/misterabc/kak/ycmd/ycmd

map global normal = '|clang-format-8<ret>'
map global insert <c-w> '<a-;>:exec -draft hbd<ret>'

map global user f ':fzf-mode<ret>'
map global user a ':alt<ret>'
map global user , ':lsp-hover<ret>'

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

add-highlighter global/ number-lines -relative
