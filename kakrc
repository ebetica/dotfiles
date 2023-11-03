source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload
plug 'delapouite/kakoune-livedown' %{
   set-option global livedown_browser 'firefox --new-window'
}
plug "https://gitlab.com/Screwtapello/kakoune-repl-buffer"

plug "andreyorst/fzf.kak" config %{
    require-module fzf
    map global user -docstring "Search only in the subdirectory of this file" e %{
        :fzf -kak-cmd %{edit -existing} -preview -items-cmd "fd --type f -L . $(dirname %val{bufname})"<ret>
    }
    map global user -docstring "Search hidden + gitignored files as well" a %{
        :fzf -kak-cmd %{edit -existing} -preview -items-cmd "fd --type f -L -H"<ret>
    }
} defer "fzf-file" %{
    set-option global fzf_file_command 'fd -L --type f'
    set-option global fzf_grep_command 'rg'
}

plug "andreyorst/smarttab.kak" config %{
    hook global WinSetOption filetype=(makefile|gas) noexpandtab
    hook global WinSetOption filetype=(rust|markdown|kak|c|cpp|python) expandtab
} defer "smarttab" %{
    echo -debug "smarttab"
    set-option global tabstop 4
    set-option global softtabstop 4
    hook global WinSetOption filetype=(yaml|json) %{ set-option window tabstop 2 }
    hook global WinSetOption filetype=(yaml|json) %{ set-option window softtabstop 2 }
}

plug "ul/kak-tree" do %{
    git submodule update --init --recursive
    cargo install --path . --force --features "rust python html javascript typescript cpp c bash json"
}

plug "kak-lsp/kak-lsp" do %{
    cargo install --locked --force --path .
}
# set global lsp_cmd "kak-lsp -s %val{session} -vvvvv --log /tmp/kak-lsp.log"
hook global WinSetOption filetype=(rust|python|go|javascript|typescript|c|cpp|sh|latex) %{
    lsp-enable-window
    lsp-auto-hover-enable
    lsp-auto-signature-help-enable
    # lsp-auto-hover-insert-mode-enable
}
set-option global lsp_auto_highlight_references true
def -hidden insert-c-n %{
  try %{
    lsp-snippets-select-next-placeholders
    exec '<a-;>d'
  } catch %{
    exec -with-hooks '<c-n>'
  }
}
map global insert <c-n> "<a-;>: insert-c-n<ret>"

plug "h-youhei/kakoune-surround"
declare-user-mode plugin
map global plugin s ':surround<ret>' -docstring 'surround'
map global plugin v ':select-surround<ret>' -docstring 'surround select'
map global plugin c ':change-surround<ret>' -docstring 'surround change'
map global plugin d ':delete-surround<ret>' -docstring 'surround delete'
map global plugin t ':select-surrounding-tag<ret>' -docstring 'surround select tag'

map global plugin j ':tree-select-next-node<ret>' -docstring 'ast next'
map global plugin k ':tree-select-previous-node<ret>' -docstring 'ast prev'
map global plugin h ':tree-select-parent-node<ret>' -docstring 'ast parents'
map global plugin l ':tree-select-first-child<ret>' -docstring 'ast child'
map global plugin L ':tree-select-children<ret>' -docstring 'ast children'
map global normal 'v' ':enter-user-mode plugin<ret>'

map global normal = ':format<ret>'
map global normal * <a-i>w*
map global normal & *
map global insert <c-w> '<a-;>:exec -draft hbd<ret>'

map global user f ':fzf-mode<ret>'
map global user <space> ':lsp-hover<ret>'
map global user l ':enter-user-mode lsp<ret>'
map global user -docstring "repl-buffer-prompt" p ':repl-buffer-prompt<ret>'
map global user -docstring "repl-buffer-send-text" s ':repl-buffer-send-text<ret>'
map global normal D ':lsp-find-error<ret>l:lsp-hover<ret>'
map global normal \' \;
map global normal <semicolon> :
map global user -docstring "Replace selection with chatgpt's answer" c '| chatgpt --model gpt-4 -i "Help me by completing this code. If you see a comment like # chatgpt: , please replace the comment with the right code and outputting everything else as is"'
map global user -docstring "Interactive chatgpt mode" i ':repl-buffer-new chatgpt --model gpt-4 --interactive <ret>:repl-buffer-prompt<ret>'
map global user -docstring "Ask chatgpt about the selection!" q '<a-|>tee /tmp/chatgpt.txt<ret>:repl-buffer-new chatgpt --model gpt-4 --interactive -i "Answer as briefly and succinctly as possible, avoiding any unnecessary words or repetition." --init-prompt-from-file /tmp/chatgpt.txt <ret>:repl-buffer-prompt<ret>'

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
hook global WinSetOption filetype=rust %{ set window formatcmd 'rustfmt' }
hook global WinSetOption filetype=json %{ set window formatcmd 'jq .' }
hook global WinSetOption filetype=xml %{ set window formatcmd 'xmllint --format -' }
hook global WinSetOption filetype=python %{
    set window formatcmd 'autoflake --remove-all-unused-imports - | isort --profile=black - | black -'
    # hacky-workaround to get linefeeds into paste buffers
    # Credit to @cole-h
    execute-keys ':set-register p "        __import__(''ipdb'').set_trace()<c-v><ret>"<ret>'
}

add-highlighter global/ number-lines -relative
face global MenuBackground default,black

set global scrolloff 10,10

