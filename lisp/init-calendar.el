
(setq chinese-calendar-celestial-stem
      ["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"])

(setq chinese-calendar-terrestrial-branch
        ["子" "丑" "寅" "卯" "辰" "巳" "午" "未" "申" "酉" "戌" "亥"])

;; (setq my-holidays '((holiday-fixed 1 14 '情人节')
;;                     (holiday-fixed 9 10 '教师节')
;;                     (holiday-float 6 0 3 '父亲节')
;;                     (holiday-lunar 1 1 '春节' 0)
;;                     (holiday-lunar 1 15 '元宵节' 0)
;;                     (holiday-solar-term '清明' '清明节')
;;                     (holiday-lunar 5 5 '端午节' 0)
;;                     (holiday-lunar 7 7 '七夕情人节' 0)
;;                     (holiday-lunar 8 15 '中秋节' 0)
;;                     (holiday-fixed 12 21 '女儿生日')
;;                     (holiday-lunar 12 3 '老婆生日' 0)
;;                     (holiday-lunar 7 19 '我的生日' 0)))
;; (setq calendar-holidays my-holidays)

(setq org-directory "~/recipes/agenda")
(setq org-agenda-files (file-expand-wildcards org-directory))
;; (setq org-agenda-files "~/recipes/cfa.org")

(setq calendar-latitude 40.08198)
(setq calendar-longitude 116.4187)
(setq calendar-location-name "Beijing, China")

(if  (< (string-to-number (format-time-string "%H")) 9)
    (calendar)
    (switch-to-buffer "*scratch*"))

(provide 'init-calendar)
