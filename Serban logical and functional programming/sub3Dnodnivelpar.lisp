(defun verificare(arbore nod pr)
  (cond
    ((null arbore) 0)
	((and (eq(car arbore) nod) (= 0 (mod pr 2))) 1)
	(T
		(apply #'+
		(mapcar (lambda(E) (verificare E nod (+ 1 pr))) (cdr arbore))
	    )
	)
  )
)
(defun wrap( arb nod)
    (verificare arb nod 0)
)

;;verificare(ar2,nod,pr)+verificare(ar3,nod,pr)+...+verificare(arn,nod,pr)