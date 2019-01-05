(require 'projectile)
 
;; 默认全局使用
(projectile-global-mode)
 
;; 默认打开缓存
(setq projectile-enable-caching t)
 
;;【现在就像浏览自己本地文件目录一样，也可以编辑响应缓慢的问题可以通过添加这行来解决】
(setq projectile-mode-line "Projectile") 
 
;; 使用f5键打开默认文件搜索
(global-set-key [f5] 'projectile-find-file)

(provide 'init-projectile)