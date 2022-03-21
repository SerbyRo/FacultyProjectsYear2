(defun nnc(E L)
  (cond
     ((null L) NIL)
	 (T (cons E L))
  )
)



(defun paths (arbore nod)
	(cond 
	  ((null arbore) NIL)
	  ((eq(car arbore) nod) (list nod))
	  (T 
	    (nnc(car arbore)
		  (some
		    (lambda(E) (paths E nod)
			
			)
			(cdr arbore)
		  )
		)
	  )
	)
 )
 
 ;;nnc(arb1,primu element nenul(paths(arb2,nod),paths(arb3,nod),...,paths(arbn,nod)))