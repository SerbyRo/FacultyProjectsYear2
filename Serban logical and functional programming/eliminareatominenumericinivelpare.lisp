(defun delete1(lista pr)
  (cond 
    ((and (=(mod pr 2) 0) (atom lista) (not (numberp lista))) NIL)
	((atom lista) (list lista))
	(T 
	 (list
	  (mapcan
	     (lambda (el)
		   (delete1 el (1+ pr))
		 )
		 lista
	   )
	  )
	)
  )
)
(defun wrap(elem)
  (delete1 elem 0)
)