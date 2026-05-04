;;; evil.el --- Test stub for Evil -*- lexical-binding: t; -*-

(defvar evil-normal-state-map (make-sparse-keymap))
(defvar evil-visual-state-map (make-sparse-keymap))
(defvar evil-search-module nil)
(defvar evil-symbol-word-search nil)

(defmacro evil--define-command-stubs (&rest names)
  `(progn
     ,@(mapcar
        (lambda (name)
          `(defun ,name ()
             ,(format "Test stub for `%s'." name)
             (interactive)))
        names)))

(evil--define-command-stubs
 evil-backward-char
 evil-forward-char
 evil-previous-line
 evil-next-line
 evil-backward-word-begin
 evil-forward-word-begin
 evil-backward-sentence-begin
 evil-forward-sentence-begin
 evil-beginning-of-line
 evil-end-of-line
 evil-backward-paragraph
 evil-forward-paragraph
 evil-scroll-page-up
 evil-scroll-page-down
 evil-delete-backward-char-and-join
 evil-delete-backward-word
 evil-delete-char
 evil-delete
 evil-append
 evil-append-line)

(provide 'evil)

;;; evil.el ends here
