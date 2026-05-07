;;; evil-gamepad.el --- Gamepad-inspired Evil bindings -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; Author: tninja
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1") (evil "1.14.0"))
;; Keywords: evil, vim, convenience
;; URL: https://github.com/tninja/evil-gamepad.el

;;; Commentary:

;; evil-gamepad provides a small, dependency-light set of Evil bindings
;; organized around a gamepad-like layout: left hand for movement,
;; right hand for editing actions.

;;; Code:

(require 'evil)

(defgroup evil-gamepad nil
  "Gamepad-inspired keybindings for Evil."
  :group 'evil
  :prefix "evil-gamepad-")

(defcustom evil-gamepad-enable-search-tweaks nil
  "When non-nil, enable Evil search settings preferred by evil-gamepad."
  :type 'boolean
  :group 'evil-gamepad)

(defconst evil-gamepad--normal-bindings
  '(("a" . evil-backward-char)
    ("d" . evil-forward-char)
    ("w" . evil-previous-line)
    ("s" . evil-next-line)
    ("q" . evil-backward-word-begin)
    ("e" . evil-forward-word-begin)
    ("Q" . tab-bar-switch-to-prev-tab)
    ("E" . tab-bar-switch-to-next-tab)
    ("A" . evil-beginning-of-line)
    ("D" . evil-end-of-line)
    ("W" . evil-backward-paragraph)
    ("S" . evil-forward-paragraph)
    ("C-w" . evil-scroll-page-up)
    ("C-s" . evil-scroll-page-down)
    ("j" . evil-gamepad-avy-goto-char)
    ("J" . avy-goto-line)
    ("k" . evil-delete-char)
    ("K" . evil-delete-backward-char-and-join)
    ("C-k" . evil-delete-backward-word)
    ("l" . evil-append)
    ("L" . evil-append-line))
  "Bindings installed into `evil-normal-state-map'.")

(defconst evil-gamepad--visual-bindings
  '(("a" . evil-backward-char)
    ("d" . evil-forward-char)
    ("w" . evil-previous-line)
    ("s" . evil-next-line)
    ("q" . evil-backward-word-begin)
    ("e" . evil-forward-word-begin)
    ("A" . evil-beginning-of-line)
    ("D" . evil-end-of-line)
    ("W" . evil-backward-paragraph)
    ("S" . evil-forward-paragraph))
  "Bindings installed into `evil-visual-state-map'.")

(defvar evil-gamepad--normal-bindings-backup nil
  "Saved bindings from `evil-normal-state-map'.")

(defvar evil-gamepad--visual-bindings-backup nil
  "Saved bindings from `evil-visual-state-map'.")

(defvar evil-gamepad--saved-symbol-word-search nil
  "Saved value of `evil-symbol-word-search'.")

(defvar evil-gamepad--saved-search-module nil
  "Saved value of `evil-search-module'.")

(defun evil-gamepad--backup-key (keymap key backup-var)
  "Save KEY in KEYMAP into BACKUP-VAR before overriding it."
  (let* ((key-description (kbd key))
         (current-binding (lookup-key keymap key-description))
         (current-backup (symbol-value backup-var)))
    (unless (assoc key current-backup)
      (set backup-var (cons (cons key current-binding) current-backup)))))

(defun evil-gamepad--restore-key (keymap backup)
  "Restore one KEYMAP binding from BACKUP."
  (define-key keymap (kbd (car backup)) (cdr backup)))

(defun evil-gamepad--install-bindings (keymap bindings backup-var)
  "Install BINDINGS into KEYMAP and record previous bindings in BACKUP-VAR."
  (dolist (binding bindings)
    (evil-gamepad--backup-key keymap (car binding) backup-var)
    (define-key keymap (kbd (car binding)) (cdr binding))))

(defun evil-gamepad--restore-bindings (keymap backups)
  "Restore KEYMAP from BACKUPS."
  (dolist (backup backups)
    (evil-gamepad--restore-key keymap backup)))

(defun evil-gamepad--apply-search-tweaks ()
  "Apply optional search tweaks."
  (setq evil-gamepad--saved-symbol-word-search evil-symbol-word-search
        evil-gamepad--saved-search-module evil-search-module)
  (setq-default evil-symbol-word-search t)
  (setq evil-search-module 'evil-search))

(defun evil-gamepad--revert-search-tweaks ()
  "Revert optional search tweaks."
  (setq-default evil-symbol-word-search evil-gamepad--saved-symbol-word-search)
  (setq evil-search-module evil-gamepad--saved-search-module))

(defun evil-gamepad-avy-goto-char ()
  "Jump to a visible character with avy when available."
  (interactive)
  (when (not (fboundp 'avy-goto-char))
    (require 'avy nil t))
  (if (fboundp 'avy-goto-char)
      (call-interactively #'avy-goto-char)
    (user-error "avy is required for this binding; install the avy package")))

(defun evil-gamepad-setup ()
  "Install evil-gamepad bindings into Evil state maps."
  (evil-gamepad--install-bindings
   evil-normal-state-map
   evil-gamepad--normal-bindings
   'evil-gamepad--normal-bindings-backup)
  (evil-gamepad--install-bindings
   evil-visual-state-map
   evil-gamepad--visual-bindings
   'evil-gamepad--visual-bindings-backup)
  (when evil-gamepad-enable-search-tweaks
    (evil-gamepad--apply-search-tweaks)))

(defun evil-gamepad-reset ()
  "Restore bindings replaced by `evil-gamepad-setup'."
  (evil-gamepad--restore-bindings
   evil-normal-state-map
   evil-gamepad--normal-bindings-backup)
  (evil-gamepad--restore-bindings
   evil-visual-state-map
   evil-gamepad--visual-bindings-backup)
  (setq evil-gamepad--normal-bindings-backup nil
        evil-gamepad--visual-bindings-backup nil)
  (when evil-gamepad-enable-search-tweaks
    (evil-gamepad--revert-search-tweaks)))

;;;###autoload
(define-minor-mode evil-gamepad-mode
  "Toggle gamepad-inspired Evil bindings."
  :global t
  :group 'evil-gamepad
  (if evil-gamepad-mode
      (evil-gamepad-setup)
    (evil-gamepad-reset)))

(provide 'evil-gamepad)

;;; evil-gamepad.el ends here
