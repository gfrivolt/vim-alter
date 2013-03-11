
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction

function! s:get_spec_for_js(filename)
  let new_name = a:filename
  let new_name = substitute(new_name, '^assets/', '', '')
  let new_name = substitute(new_name, '\.js\.coffee', '_spec.js.coffee', '')
  let new_name = 'spec/' . new_name
  return new_name
endfunction

function! s:get_spec_for_rb(filename)
  let new_name = a:filename
  let new_name = substitute(new_name, '\.rb$', '_spec.rb', '')
  let new_name = 'spec/' . new_name
  return new_name
endfunction

function! s:get_code_for_js(filename)
  let new_name = a:filename
  let new_name = substitute(new_name, '_spec\.js\.coffee$', '.js.coffee', '')
  let new_name = substitute(new_name, '^spec/', '', '')
  let new_name = 'assets/' . new_name
  return new_name
endfunction

function! s:get_code_for_rb(filename)
  let new_name = a:filename
  let new_name = substitute(new_name, '_spec\.rb$', '.rb', '')
  let new_name = substitute(new_name, '^spec/', '', '')
  return new_name
endfunction

function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 ||
        \match(current_file, '\<models\>') != -1 ||
        \match(current_file, '\<views\>') != -1 ||
        \match(current_file, '\<helpers\>') != -1
  let in_js = match(current_file, '\<javascripts\>') != -1
  if going_to_spec
    let new_file = substitute(new_file, '^app/', '', '')
    if in_js
      let new_file = s:get_spec_for_js(new_file)
    else
      let new_file = s:get_spec_for_rb(new_file)
    end
  else " going to code
    if in_js
      let new_file = s:get_code_for_js(new_file)
    else
      let new_file = s:get_code_for_rb(new_file)
    end
    let new_file = 'app/' . new_file
  endif
  return new_file
endfunction

nnoremap <leader>.  :call OpenTestAlternate()<cr>
