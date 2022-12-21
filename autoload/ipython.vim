fu! ipython#what(exe='ipython')
  exec 'te ' .a:exe
  set cursorcolumn
endfu

fu! ipython#new()
  new
  let s:winId = win_getid()
  let s:bufNr = bufnr()
  call ipython#what()
  let s:jobId = b:terminal_job_id
  call terminal#winIds({'python': s:winId})
  let s:jobName = nvim_buf_get_name(0)
endfu

fu! ipython#go(hide=0)
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
        call terminal#winIds({'python': s:winId})
        try
          exec 'b ' .s:bufNr
          exec 'bw! ' .tmpBufNr
        catch
          let s:bufNr = bufnr()
          call ipython#what()
          let s:jobId = b:terminal_job_id
          let s:jobName = nvim_buf_get_name(0)
        endtry
      endif
    endif
  else
    call ipython#new()
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

fu! ipython#runShow(cmd)
  call ipython#go()
  call chansend(s:jobId, [a:cmd, ''])
  norm G
  wincmd K
endfu

fu! ipython#runHide(cmd)
  call ipython#go(1)
  call chansend(s:jobId, [a:cmd, ''])
endfu

fu! ipython#hide()
  call ipython#go(1)
endfu

fu! ipython#toggle()
  call ipython#go(2)
endfu

fu! ipython#kill()
  call ipython#go(3)
endfu

fu! ipython#send(mode)
  if a:mode == 0
    call ipython#runShow(getline('.'))
  elseif a:mode == 1
    for i in terminal#getVisualSelection('')
      let aws = trim(i)
      if len(aws) > 0
        call ipython#runShow(aws)
      endif
    endfor
  endif
  wincmd p
endfu
