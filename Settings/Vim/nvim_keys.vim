
" Denite
nnoremap <leader>f :Denite file/rec<return>
nnoremap <leader>b :Denite buffer<return>
nnoremap <leader>g :Denite grep<return>
nnoremap <leader>F :DeniteBufferDir file/rec<return>
nnoremap <leader>G :DeniteBufferDir grep<return>
nnoremap <leader>O :Denite output:!

" " Copy to clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P