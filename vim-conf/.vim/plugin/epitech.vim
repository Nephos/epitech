
function UpdateHeaderDate()
  let save_cursor  = getpos(".")
  let la = "## Last update @@MDATE@@ @@MAUTHOR@@"
  let la = substitute(la, "@@MDATE@@", strftime("%a %b %d %H:%M:%S %Y"), "ge")
  let la = substitute(la, "@@MAUTHOR@@", $EPI_NAME, "ge")
  execute "silent %s,^## Last update.*," . la . ",ge"
  let lu = "** Last update @@MDATE@@ @@MAUTHOR@@"
  let lu = substitute(lu, "@@MDATE@@", strftime("%a %b %d %H:%M:%S %Y"), "ge")
  let lu = substitute(lu, "@@MAUTHOR@@", $EPI_NAME, "ge")
  execute "silent %s,^\*\* Last update.*," . lu . ",ge"
  call setpos('.', save_cursor)
endfunction

function SetHeader(name)
  let save_cursor  = getpos(".")
  execute "%s,@@FNAME@@," . expand("%:t") . ",ge"
  execute "%s,@@PNAME@@," . a:name . ",ge"
  execute "silent %s,@@HDR_NAME@@," . toupper(substitute(expand("%:t"),'\..*$',  "","ge")) . ",ge"
  execute "%s,@@FPATH@@," . substitute(expand("%:p"), '/[^/]*$', "", "ge") . ",ge"
  execute "%s,@@AUTHOR@@," . $EPI_NAME . ",ge"
  execute "%s,@@AUTHORMAIL@@," . substitute(tolower($EPI_NAME), " ", ".", "ge") . "@epitech.eu,ge"
  execute "%s,@@CDATE@@," . strftime("%a %b %d %H:%M:%S %Y") . ",ge"
  call setpos('.', save_cursor)
endfunction

function Epi_Header_Insert()
  if(&ft == 'make')
    0r ~/.vim/skel/epi_make.tpl
  else
    silent! 0r ~/.vim/skel/epi_%:e.tpl
  endif
  let name = input('Project name :')
  call SetHeader(name)
  call UpdateHeaderDate()
  normal G
endfunction
