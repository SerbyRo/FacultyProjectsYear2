(defun replace1(lista nivel)
 (cond
   ((null lista) NIL)
   ((= nivel 0)
     (cond 
	   ((atom lista) 0)
	   (T lista)
	 )
   )
   ((atom lista) lista) 
   (T (mapcar (lambda (el) (replace1 el (1- nivel)))lista))
   ;;replace1(lista1,nivel-1)U replace1(lista2,nivel-1)U...U(listan,nivel-1)
 )
)