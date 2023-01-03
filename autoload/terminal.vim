fu! terminal#systemCd(absfolder)
  if !isdirectory(a:absfolder)
    return ''
  endif
  return a:absfolder[0] .': && cd ' .a:absfolder
endfu

fu! terminal#isLastWindow()
  let str_ret = execute("tabs")
  let list_ret = split(str_ret, '\n')
  if index(list_ret, 'Tab page 2') != -1
    return 0
  endif
  call remove(list_ret, index(list_ret, 'Tab page 1'))
  let bufs = []
  for r in list_ret
    if '' != r && match(r, '\[Scratch\]') == -1
      let bufs += [r]
    endif
  endfor
  if len(bufs) == 1
    return 1
  endif
  return 0
endfu

fu! terminal#hidedo()
  if terminal#isLastWindow()
    if &modifiable && !&modified && !len(expand('%:p'))
      ec 'no hide'
      return
    endif
    new
    wincmd p
    hide
    return
  endif
  hide
endfu

fu! s:escape(abspath)
  return substitute(a:abspath, '/', '\', 'g')
endfu

fu! terminal#tryGoTo(abspath)
  let go = 0
  for tabIndex in range(1, tabpagenr('$'))
    let bufs = tabpagebuflist(tabIndex)
    for winIndex in range(len(bufs))
      let bufNr = bufs[winIndex]
      if nvim_buf_is_valid(bufNr)
        if s:escape(nvim_buf_get_name(bufNr)) == s:escape(a:abspath)
          call win_gotoid(win_getid(winIndex+1, tabIndex))
          let go = 1
          break
        endif
      endif
    endfor
  endfor
  return go
endfu

if !exists('s:idList')
  let s:idList = {}
endif

fu! terminal#what(exe='')
  exec 'te ' .a:exe
  set cursorcolumn
endfu

fu! terminal#new()
  new
  let s:winId = win_getid()
  let s:bufNr = bufnr()
  call terminal#what()
  let s:jobId = b:terminal_job_id
  call terminal#winIds({'terminal': s:jobId})
  let s:jobName = nvim_buf_get_name(0)
endfu

fu! terminal#go(hide)
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
        call terminal#winIds({'terminal': s:winId})
        try
          exec 'b ' .s:bufNr
          exec 'bw! ' .tmpBufNr
        catch
          let s:bufNr = bufnr()
          call terminal#what()
          let s:jobId = b:terminal_job_id
          let s:jobName = nvim_buf_get_name(0)
        endtry
      endif
    endif
  else
    call terminal#new()
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

fu! terminal#runShow(cmd)
  call terminal#go(0)
  call chansend(s:jobId, [a:cmd, ''])
  norm G
  wincmd K
endfu

fu! terminal#runHide(cmd)
  call terminal#go(1)
  call chansend(s:jobId, [a:cmd, ''])
endfu

fu! terminal#hide()
  call terminal#go(1)
endfu

fu! terminal#toggle()
  call terminal#go(2)
endfu

fu! terminal#kill()
  call terminal#go(3)
endfu

fu! terminal#changeCur()
  call chansend(s:jobId, [terminal#systemCd(expand('%:p:h')), ''])
endfu

fu! terminal#winIds(dict)
  if type(a:dict) == v:t_dict
    call extend(s:idList, a:dict)
  elseif type(a:dict) == v:t_string
    try
      return s:idList[a:dict]
    catch
      return ''
    endtry
  else
    return ''
  endif
endfu

fu! terminal#hideAll()
  if len(s:idList)
    for winid in values(s:idList)
      try
        call nvim_win_hide(winid)
      catch
      endtry
    endfor
  endif
endfu

fu! terminal#hideAllYes()
  call terminal#hide()
  call bash#hide()
  call ipython#hide()
  call powershell#hide()
endfu
