(defun height(elem elcautat nivel)
 (cond
    ((eq elem elcautat) nivel)
	((atom elem) -1)
	(T 
      (apply #'max
	  (mapcar
	     (lambda(L)
		   (height L elcautat (1+ nivel))
		 )
		 elem
	  )
	  )
	)
 )
)

(defun wrap(elem elcautat)
    (height elem elcautat -1)
)

;;max(height(elem1,elcautat,nivel+1),height(elem2,elcautat,nivel+1),...,height(elemn,elcautat,nivel+1))