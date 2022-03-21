(defun numarasuperficiale(lista)
	(cond 
		((NULL lista) 0)
		((atom (CAR lista)) (+ 1 (numarasuperficiale (CDR lista))))
		(T (numarasuperficiale(CDR lista)))
	)
)

(defun impare (lista flag)
	(cond
	    ((NULL lista) NIL)
		((and flag (=(mod (numarasuperficiale lista) 2) 1))
		(cond
			((atom (CAR lista)) (cons (CAR lista) (impare (CDR lista) NIL)))
			(T (cons (CAR lista) (combinaliste (impare (CAR lista) T) (impare (CDR lista) NIL))))
		)
	  )
	  (T (cond 
		((atom(CAR lista)) (impare (CDR lista) NIL))
		(T (combinaliste (impare (CAR lista) T) (impare (CDR lista) NIL)))
	  ))
	)
)

(defun combinaliste(lista lista1)
	(cond
	((NULL lista) lista1)
	(T (cons (CAR lista) (combinaliste (CDR lista) lista1)))
	)
)


(defun wrapper (lista)
    (impare lista T)
)