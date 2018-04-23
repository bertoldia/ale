" Author: Jeff Willette <jrwillette88@gmail.com>
" Description: Integration of importjs with ALE.

call ale#Set('javascript_importjs_executable', 'importjs')
call ale#Set('javascript_importjs_use_global', get(g:, 'ale_use_global_executables', 0))
call ale#Set('javascript_importjs_options', '')

function! ale#fixers#importjs#ProcessOutput(buffer, output) abort
    let l:result = ale#util#FuzzyJSONDecode(a:output, [])

    return split(get(l:result, 'fileContent', ''), "\n")
endfunction

function! ale#fixers#importjs#GetExecutable(buffer) abort
    return ale#node#FindExecutable(a:buffer, 'javascript_importjs', [
    \   'node_modules/.bin/importjs',
    \])
endfunction

function! ale#fixers#importjs#Fix(buffer) abort
    let l:executable = ale#fixers#importjs#GetExecutable(a:buffer)
    let l:options = ale#Var(a:buffer, 'javascript_importjs_options')

    if !executable(l:executable)
        return 0
    endif

    return {
    \   'command': ale#Escape(l:executable)
    \       . ' fix'
    \       . ' %s',
    \   'process_with': 'ale#fixers#importjs#ProcessOutput',
    \}
endfunction
