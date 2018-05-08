;; -*- coding: utf-8 -*-
;; 2011-10-15
;; some fix for 'dictionary packgage.
;; for detail, see 〈Emacs Dictionary Lookup〉 @ http://ergoemacs.org/emacs/dictionary_lookup.html
;; Xah Lee

(require 'dictionary)
(require 'browse-url)
(require 'xfrp_find_replace_pairs "xfrp_find_replace_pairs.elc")
(require 'xeu_elisp_util "xeu_elisp_util.elc")

;; 2011-10-15 you can get {xfrp_find_replace_pairs, xeu_elisp_util} at 〔http://code.google.com/p/ergoemacs/source/browse/#svn%2Ftrunk%2Fpackages〕

(defun lookup-word-definition-in-emacs (&optional input-word)
  "Look up the word's definition in WordNet, Webster 1913, Moby Thesaurus.
If there is a text selection (a phrase), lookup that phrase.
This command needs Torsten Hilbrich's dictionary.el installed."
  (interactive)
  (require 'dictionary)
  (let (ξword dictResult navigText p1 )
    (setq ξword (if input-word input-word (elt (get-selection-or-unit 'word) 0) ) )
    (setq ξword (asciify-text ξword))

   (setq dictResult "")
   ;; (dictionary-do-search "fancy" "web1913" 'dictionary-display-search-result)

;;   (dictionary-do-search ξword "wn" 'dictionary-display-search-result t) ; wordnet
   (dictionary-new-search (cons ξword "wn"))
   (setq dictResult (concat dictResult (buffer-string)))

;;   (dictionary-do-search ξword "web1913" 'dictionary-display-search-result t)
   (dictionary-new-search (cons ξword "web1913"))
   (setq dictResult (concat dictResult (buffer-string)))

;;   (dictionary-do-search ξword "moby-thes" 'dictionary-display-search-result t)
   (dictionary-new-search (cons ξword "moby-thes"))
   (setq dictResult (concat dictResult (buffer-string)))

   (switch-to-buffer "*my dict results*")
   (erase-buffer)
   (dictionary-mode)
   (insert dictResult)
   (goto-char 1) (forward-line 2)
   (setq p1 (point))

   (setq navigText (buffer-substring 1 p1))

   (goto-char 1)
   ;; remove navigation text
   (while
       (search-forward
        "[Back] [Search Definition]         [Matching words]        [Quit]
       [Select Dictionary]         [Select Match Strategy]
" nil t
        )
     (replace-match "────────────────────" t t))

   ;; remove message about how many def found. e.g. “1 definition found”.
   (goto-char 1)
   (while
       (search-forward-regexp "[0-9]+ definitions* found\n\n" nil t)
     (replace-match "" t t))

   (goto-char (point-max))
   (insert navigText)
   (goto-char 1)
   (other-window 1)
   ))