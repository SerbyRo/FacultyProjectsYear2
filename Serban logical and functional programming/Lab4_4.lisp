(defun suma (lista)
	(cond
		((NULL lista) 0)
		((numberp (CAR lista)) (+ (CAR lista) (suma (CDR lista))))
		(T (suma (CDR lista)))
	)
)