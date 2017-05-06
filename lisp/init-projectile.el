;; init-projectile.el --- Initialize projectile configurations.
;;
;; Author: Vincent Zhang <seagle0128@gmail.com>
;; Version: 2.2.0
;; URL: https://github.com/seagle0128/.emacs.d
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;             Projectile configurations.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(require 'init-const)

;; Manage and navigate projects
(use-package projectile
  :bind (("C-S-t" . projectile-find-file)
         ("s-t" . projectile-find-file))
  :init (add-hook 'after-init-hook 'projectile-mode)
  :config
  (setq projectile-mode-line
        '(:eval (format "[%s]" (projectile-project-name))))

  (setq projectile-indexing-method 'alien)
  (setq projectile-enable-caching nil)
  (setq projectile-sort-order 'access-time)
  (setq projectile-use-git-grep t)

  ;; Use faster search tools
  (cond
   ((executable-find "rg")
    (setq projectile-generic-command "rg -0 --files --color=never --hidden --sort-files"))
   ((executable-find "ag")
    (setq projectile-generic-command
          (concat "ag -0 -l --nocolor --hidden"
                  (mapconcat #'identity (cons "" projectile-globally-ignored-directories) " --ignore-dir=")))))

  ;; Faster searching on Windows
  (when sys/win32p
    (setq projectile-git-command projectile-generic-command)
    (setq projectile-svn-command projectile-generic-command)
    (setq projectile-bzr-command projectile-generic-command)
    (setq projectile-hg-command projectile-generic-command))

  ;; Support Perforce project
  (let ((val (or (getenv "P4CONFIG") ".p4config")))
    (add-to-list 'projectile-project-root-files-bottom-up val))

  ;; Support ripgrep
  (use-package projectile-ripgrep
    :bind (:map projectile-mode-map
                ("C-c p s r" . projectile-ripgrep)))

  ;; Rails project
  (use-package projectile-rails
    :diminish projectile-rails-mode
    :init (projectile-rails-global-mode 1)))

(provide 'init-projectile)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-projectile.el ends here
