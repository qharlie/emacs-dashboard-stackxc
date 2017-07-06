(require 'json)
(add-to-list 'dashboard-item-generators  '(stackxc . dashboard-insert-sx))
(add-to-list 'dashboard-items '(stackxc) t)

(defun dashboard-insert-sx-list (title list)
  "Render SX-LIST title and items of LIST."
  (when (car list)
    (insert title )
    (mapc (lambda (el)
	    (setq link (nth 1 (split-string el "__")) )
	    (setq link-title (nth 0 (split-string el "__")) )
            (insert "\n    ")
            (widget-create 'push-button
                           :action `(lambda (&rest ignore)
				      (browse-url , link))
                           :mouse-face 'highlight
                           :follow-link "\C-m"
                           :button-prefix ""
                           :button-suffix ""
                           :format "%[%t%]"	    
			   link-title
			   ))
          list)))
(defun dashboard-insert-sx (list-size)
  "Add the list of LIST-SIZE items from recently edited files."
  (if (> list-size 0 )
      (progn
	
	(setq stackxc-file-path "/tmp/dashboard_stackxc.json")
	(condition-case nil
	    (delete-file stackxc-file-path)
	  (error nil))


	(url-copy-file "https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=emacs"  stackxc-file-path)
	(setq sx-list (mapcar (lambda (entry)
				    (format "views(%s)\t  %s__%s " (let-alist entry .view_count ) (let-alist entry .title ) (let-alist entry .link )))
					;(concat (let-alist entry .data.title ) (concat " - " (let-alist entry .data.url ))))
				  (let-alist (json-read-file  stackxc-file-path) .items )))


	(when (dashboard-insert-sx-list
	       "Recent Items on emacs.stackexchange.com :"
	       (dashboard-subseq sx-list 0 list-size)))	 
	;(dashboard-insert--shortcut "p" "Recent Stackexchange Emacs items:")
	)
    
    ))

