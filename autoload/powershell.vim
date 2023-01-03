fu! powershell#what(exe='powershell')
  exec 'te ' .a:exe
  set cursorcolumn
endfu

fu! powershell#new()
  new
  let s:winId = win_getid()
  let s:bufNr = bufnr()
  call powershell#what()
  call terminal#winIds({'powershell': s:winId})
  let s:jobId = b:terminal_job_id
  let s:jobName = nvim_buf_get_name(0)
endfu

fu! powershell#go(hide=0)
  let rightThere = 0
  if a:hide == 2
    if exists('s:jobName') && s:jobName == nvim_buf_get_name(0)
      let rightThere = 1
    endif
  endif
  if exists('s:winId')
    if !win_gotoid(s:winId)
      if !terminal#tryGoTo(s:jobName)
        new
        let tmpBufNr = bufnr()
        let s:winId = win_getid()
        call terminal#winIds({'powershell': s:winId})
        try
          exec 'b ' .s:bufNr
          exec 'bw! ' .tmpBufNr
        catch
          let s:bufNr = bufnr()
          call powershell#what()
          let s:jobId = b:terminal_job_id
          let s:jobName = nvim_buf_get_name(0)
        endtry
      endif
    endif
  else
    call powershell#new()
  endif
  if a:hide == 1
    call terminal#hidedo()
  elseif a:hide == 2
    if rightThere == 1
      call terminal#hidedo()
    endif
  elseif a:hide == 3
    bw!
  endif
endfu

fu! powershell#runShow(cmd)
  call powershell#go()
  call chansend(s:jobId, [a:cmd, ''])
  norm G
  wincmd K
endfu

fu! powershell#runHide(cmd)
  call powershell#go(1)
  call chansend(s:jobId, [a:cmd, ''])
endfu

fu! powershell#hide()
  call powershell#go(1)
endfu

fu! powershell#toggle()
  call powershell#go(2)
endfu

fu! powershell#kill()
  call powershell#go(3)
endfu
