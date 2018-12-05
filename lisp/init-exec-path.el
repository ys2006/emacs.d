;; -*- coding: utf-8; lexical-binding: t; -*-

(eval-after-load 'exec-path-from-shell
  '(progn
     (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO"))
       (add-to-list exec-path-from-shell-variables var))))

 (when (and window-system
            (memq window-system '(mac ns)))
   (exec-path-from-shell-initialize))

 (when (memq system-type '(windows-nt ms-dos cygwin))
   (let(
         (mypaths
          '(
           "c:/Users/dyyin/.babun/cygwin/bin/"
           "C:/Program Files/TortoiseGit/bin"
          ))
        )
    (setenv "PATH" (mapconcat 'identity mypaths ";"))
    (setq exec-path (append mypaths 'exec-directory))
  ))
 (provide 'init-exec-path)
