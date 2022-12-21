"terminal
map  tt      <cmd>:call terminal#toggle()<cr>
vmap tt <esc><cmd>:call terminal#toggle()<cr>
map  tT      <cmd>:call terminal#kill()<cr>
vmap tT <esc><cmd>:call terminal#kill()<cr>

nnoremap t.t <cmd>:call terminal#changeCur()<cr>

map ta <esc><cmd>:call terminal#hideAll()<cr>
map tA <esc><cmd>:call terminal#hideAllYes()<cr>


"python
map  tp      <cmd>:call ipython#toggle()<cr>
vmap tp <esc><cmd>:call ipython#toggle()<cr>
map  tP      <cmd>:call ipython#kill()<cr>
vmap tP <esc><cmd>:call ipython#kill()<cr>
nmap t<cr>      <cmd>:call ipython#send(0)<cr>
vmap t<cr> <esc><cmd>:call ipython#send(1)<cr>


"powershell
map  ts      <cmd>:call powershell#toggle()<cr>
vmap ts <esc><cmd>:call powershell#toggle()<cr>
map  tS      <cmd>:call powershell#kill()<cr>
vmap tS <esc><cmd>:call powershell#kill()<cr>


"bash
map  tb      <cmd>:call bash#toggle()<cr>
vmap tb <esc><cmd>:call bash#toggle()<cr>
map  tB      <cmd>:call bash#kill()<cr>
vmap tB <esc><cmd>:call bash#kill()<cr>

nnoremap t.b <cmd>:call bash#changeCur()<cr>
