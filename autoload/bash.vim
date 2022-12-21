fu! bash#what(exe='bash')
  exec 'te ' .a:exe
  set cursorcolumn
endfu

fu! bash#new()
  new
  let s:winId = win_getid()
  let s:bufNr = bufnr()
  call bash#what()
  call terminal#winIds({'bash': s:winId})
  let s:jobId = b:terminal_job_id
  let s:jobName = nvim_buf_get_name(0)
endfu

fu! bash#go(hide)
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
        call terminal#winIds({'bash': s:winId})
        try
          exec 'b ' .s:bufNr
          exec 'bw! ' .tmpBufNr
        catch
          let s:bufNr = bufnr()
          call bash#what()
          let s:jobId = b:terminal_job_id
          let s:jobName = nvim_buf_get_name(0)
        endtry
      endif
    endif
  else
    call bash#new()
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

fu! bash#runShow(cmd)
  call bash#go(0)
  call chansend(s:jobId, [a:cmd, ''])
  norm G
  wincmd K
endfu

fu! bash#runHide(cmd)
  call bash#go(1)
  call chansend(s:jobId, [a:cmd, ''])
endfu

fu! bash#hide()
  call bash#go(1)
endfu

fu! bash#toggle()
  call bash#go(2)
endfu

fu! bash#kill()
  call bash#go(3)
endfu

fu! bash#changeCur()
  call chansend(s:jobId, ['cd ' .substitute(expand('%:p:h'), '\', '/', 'g'), ''])
endfu

