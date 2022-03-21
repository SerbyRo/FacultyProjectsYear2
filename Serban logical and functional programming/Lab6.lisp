(defun substituire (element elem lista1)
	(cond
	 ((equal element elem) lista1)
	 ((atom element) element)
	 (T (mapcar(lambda (el)(substituire el elem lista1)) element ))
	)
)