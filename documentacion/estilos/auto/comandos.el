(TeX-add-style-hook "comandos"
 (lambda ()
    (LaTeX-add-environments
     "defin")
    (LaTeX-add-labels
     "#4"
     "#2")
    (TeX-add-symbols
     '("ejemplo" 1)
     '("dia" 4)
     '("figura" 5)
     '("sigla" 1)
     '("subrayado" 1)
     '("negrita" 1)
     '("comando" 1)
     '("cursiva" 1)
     '("programa" 1)
     "Hrule"
     "HRule"
     "whline")))

