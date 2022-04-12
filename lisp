# -*- mode: org; -*-

#+BIND: org-export-filter-final-output-functions (mi-filtro-columnas mi-filtro-extrae-fuente mi-filtro-barrera mi-filtro-markright mi-filtro-extrae-unidad mi-filtro-extrae-nota mi-filtro-extrae-elabora mi-filtro-imagen-etiqueta)


#+begin_src emacs-lisp :exports results :results none
   (defun mi-filtro-columnas (etea backend info)
     "dos columnas"
     (when (org-export-derived-backend-p backend 'latex)
       (replace-regexp-in-string
        "\\(xxx\\)\\(begin\\|end\\)multicols\\([[:digit:]]?\\)"
        "\\\\\\2{multicols}{\\3}"
        etea)
       )
     )
#+end_src

#+begin_src emacs-lisp :exports results :results none
  (defun mi-nofiltro-barrera (etea backend info)
    "Barrera - Actuaciones"
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       "\\(\\\\paragraph\\**\\){\\(.*\\)}
\\(.*\\)"
       "\\\\clearpage\\\\loadgeometry{centradaplus}
\\\\begin{tcolorbox}[arc=0mm,enhanced,colframe=green!50!black,fonttitle=\\\\bfseries\\\\sffamily\\\\actua,title=Actuaciones,breakable]" etea)
      )
    )
#+end_src

#+begin_src emacs-lisp :exports results :results none
  (defun mi-filtro-barrera (etea backend info)
    "Barrera - Actuaciones"
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       "\\(\\\\paragraph\\**\\){\\(.*\\)}
\\(.*\\)"
       "\\\\FloatBarrier\\\\bigskip
\\\\begin{tcolorbox}[arc=0mm,width=13.1cm,enhanced,toggle enlargement=evenpage,grow to right by=42mm,floatplacement=h,float,colframe=green!50!black,fonttitle=\\\\bfseries\\\\sffamily\\\\actua,title=Actuaciones,breakable]" etea)
      )
    )
#+end_src


#+begin_src emacs-lisp :exports results :results none
  (defun mi-filtro-markright (etea backend info)
    "Inserta markright en las section. Es totalmente necesario para
  las section*. Si es muy larga la section y tiene `:` la recorta
  con los primeros caracteres antes de `:` "
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       "\\(\\\\section\\|\\\\subsection\\|\\\\subsubsection\\){\\(.*\\)}"
       (lambda (sec)
         (let (contenido distancia recorte )
           (setq contenido (substring (match-string 2 sec)))
           (setq distancia (save-match-data (length (car (split-string contenido ":")))))
           (setq recorte (substring contenido 0 distancia))
           (concat "\\1[" recorte "]{\\2}")
           ))
       etea)
      )
    )
#+end_src

#+begin_src emacs-lisp :exports results :results none
  (defun mi-filtro-destacado (etea backend info)
    "destacado en azul"
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       "\\\\textbf"
       "\\\\destacado" etea)))
#+end_src

#+begin_src emacs-lisp :exports results :results none
  (defun imagenes-sin-centrar (backend)
    (setq org-latex-images-centered nil))

  (add-hook 'org-export-before-parsing-hook 'imagenes-sin-centrar)
#+end_src

#+begin_src emacs-lisp :exports results :results none
  (defun mi-filtro-parte (etea backend info)
    "Nueva geometria para las Partes"
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       "\\\\part{\\(.*\\)}"
       "\\\\newgeometry{left=3cm,right=3cm,textheight=25cm,top=2.5cm,headsep=0.9cm,headheight=.6cm}
  \\\\part{\\1}
  \\\\restoregeometry" etea)))
#+end_src

#+begin_src emacs-lisp :exports results :results none
  (defun mi-filtro-bloque (etea backend info)
    "Nueva geometria para los bloques"
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       "\\\\chapter{\\(Competitividad\\|Sostenibilidad\\|Conectividad\\|Bienestar\\|Territorio\\|Gobernanza\\)}"
       "\\\\newgeometry{left=3cm,right=3cm,textheight=25cm,top=2.5cm,headsep=0.9cm,headheight=.6cm,inner=1.8cm,marginparsep=0.4cm,marginparwidth=4.6cm}
  \\\\chapter{\\1}" etea)))
#+end_src

#+begin_SRC emacs-lisp :exports results :results none
  (defun extrae-atributos (backend)
    (org-map-entries
     (lambda ()
       (let ((pfuente (org-entry-get (point) "fuente"))
             (pnota (org-entry-get (point) "nota"))
             (punidad (org-entry-get (point) "unidad"))
             (pelabora (org-entry-get (point) "elabora"))
             )
         (setq fuente pfuente)
         (setq nota pnota)
         (setq unidad punidad)
         (setq elabora pelabora)
         (goto-char (line-beginning-position 2))
         (insert (concat "\n:F:\\textsf{\\bfseries\\cb Fuente: }" fuente ":F:\n"))
         (if unidad
             (insert (concat ":U:\\par\\smallskip{\\bfseries\\cb Unidad: }" unidad ":U:\n"))
           (insert (concat ":U:" ":U:") "\n"))
         (if nota
             (insert (concat ":N:\\par\\smallskip{\\bfseries\\cb Nota: }" nota ":N:\n"))
           (insert (concat ":N:" ":N:") "\n"))
         (if elabora
             (insert (concat ":E:\\par\\smallskip{\\bfseries\\cb Elaboración: }" elabora ":E:\n"))
           (insert (concat ":E:" ":E:") "\n"))
         ))
     "+graf"))
  (add-hook 'org-export-before-processing-hook 'extrae-atributos)
#+end_SRC

#+begin_SRC emacs-lisp :exports results :results none
  (defun mi-filtro-extrae-fuente (etea backend info)
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       ":F:\\(.*\\):F:"
       ":F:\\\\textsf{\\\\bfseries\\\\cb Fuente: }\\1:F:"
       etea t)))

  (defun mi-filtro-extrae-unidad (etea backend info)
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       ":U:\\(.*\\):U:"
       (lambda (unidad)
         (concat (if (equal 6 (length (concat unidad)))
                     (concat ":U::U:")
                   (concat ":U:\\\\par\\\\smallskip{\\\\bfseries\\\\cb Unidad: }\\1:U:"))))
       etea t)))

  (defun mi-filtro-extrae-nota (etea backend info)
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       ":N:\\(.*\\):N:"
       (lambda (unidad)
         (concat (if (equal 6 (length (concat unidad)))
                     (concat ":N::N:")
                   (concat ":N:\\\\par\\\\smallskip{\\\\bfseries\\\\cb Nota: }\\1:N:"))))
      etea t)))

  (defun mi-filtro-extrae-elabora (etea backend info)
    (when (org-export-derived-backend-p backend 'latex)
      (replace-regexp-in-string
       ":E:\\(.*\\):E:"
       (lambda (unidad)
         (concat (if (equal 6 (length (concat unidad)))
                     (concat ":E::E:")
                   (concat ":E:\\\\par\\\\smallskip{\\\\bfseries\\\\cb Elaboración: }\\1:E:"))))
       etea t)))
#+end_SRC


#+begin_src emacs-lisp :exports results :results none
  (defun mi-filtro-imagen-etiqueta (imagen backend info)
    "exportacion latex imagen y etiqueta lateral"
    (when (org-export-derived-backend-p backend 'latex)
      (setq sustituto (princ "\\\\begin{figure}[!hbt]
     \\\\mysidelegend{\\6}
     {\\5}
     {\\1\\2\\3\\4}
  \\\\end{figure}"))
      (replace-regexp-in-string
       ":F:\\(.*\\):F:
  :U:\\(.*\\):U:
  :N:\\(.*\\):N:
  :E:\\(.*\\):E:
  \\\\begin{figure}\\[htbp]

  \\\\includegraphics\\[width=.9\\\\linewidth]{\\(.*\\)}
  \\\\caption{\\(.*\\)}
  \\\\end{figure}"
        sustituto imagen)
       )
     )
#+end_src
