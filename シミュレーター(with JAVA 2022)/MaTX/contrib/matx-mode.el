;; -*- Mode: Emacs-Lisp -*-
;; File:            matx-mode.el
;; Description:     Mode for editing MaTX code
;; Author(s):       1995-1999 KIYOTA Hiromitsu
;;                  1999-     TANIGUCHI Yasuaki <yasuaki@matx.org>
;;                  Done by fairly faithful modification of:
;;                     C++-mode seen as below.
;;   Copyright (c) Hiromitsu Kiyota, Yasuaki Taniguchi
;;   Under GPL2.0 or later
;;
;; Special Thanks To: Masanobu Koga <Koga@MaTX.ORG>
;; Contributor(s):
;;
;; Last Modified:   $Date: 1999/10/22 15:29:09 $
;; Version:         $Revision: 1.25 $
;; Working Host(s): tanizaki.ds.mei.titech.ac.jp
;;                  hakushu.ds.mei.titech.ac.jp (aka uraissa)
;;                  camus.matx.org (aka camus.ds.mei.titech.ac.jp)
;;                  naruto (-:

;;; Original authors of C++-mode & version:
;;;   Authors:         1992 Barry A. Warsaw, Century Computing Inc.
;;;                    1987 Dave Detlefs  (dld@cs.cmu.edu)
;;;                     and Stewart Clamen (clamen@cs.cmu.edu)
;;;                    Done by fairly faithful modification of:
;;;                    c-mode.el, Copyright (C) 1985 Richard M. Stallman.
;;;   Last Modified:   Date: 1992/05/08 20:47:38
;;;   Version:         Revision: 2.40

;; Do a "C-h m" in a matx-mode buffer for more information on customizing
;; matx-mode.
;;
;; If you have problems or questions, you can contact me at the
;; following address: MaTX@MaTX.ORG (MaTX ML)
;;
;; To submit bug reports hit "C-c b" in a matx-mode buffer. This runs
;; the command matx-submit-bug-report and automatically sets up the
;; mail buffer with all the necessary information.

;; Archives on the Net:
;;  In plain text:
;;    <URL:ftp://ftp.matx.org/pub/MaTX/contrib/matx-mode.el>
;;  In Linux RPM package(s):
;;    <URL:ftp://ftp.matx.org/pub/MaTX/Linux/Linux-2_x/redhat/RPMS/noarch/>

;; NOTE: This is beta-FOUR-a, but is being distributed on the Net now a days.
;;       Anyway, I call it beta.  Any comments and suggestions are welcome.


;; A List To Do: <1997/03/09>
;;   o a variable matx-scan-lists-bug-exists defined, default to nil.
;;   o matx-begin-of-defun, matx-end-of-defun => mark-matx-defun
;;   o mail aliases setting (matx-mode-help, matx-mode-victims{,-request})
;; <1998/07/31> o complete control of matx buffer and process in matx-program.
;;   (In Linux1.2.13(uraissa), matx process is killed normally.  In SunOS
;;    4.1.4J(dazai), process sometimes remains. X)


;; matx-mode requires c-mode since it's hacked from ancient c++-mode which
;; was derived from c-mode. ;)
;; Why c-mode-syntax-table?  It's one of necessary variables for a mode.
;; Just one of many hacks (or dirty tricks) in this code. B)
;;   written by KIYOTA Hiromitsu <1998/01/22>
(if (not (boundp 'c-mode-syntax-table))
    (require 'c-mode))

(if (featurep 'hilit19) ;; inserted by HiK. <1997/05/18>
    (hilit-set-mode-patterns
     'matx-mode
     (append
      '(
	("/\\*" "\\*/" comment)       ;comments
	("//.*$" nil comment)         ;c++/matx-comments
	("^/.*$" nil comment)         ; ditto
	(hilit-string-find ?' string) ;strings
	("^#[ \t]*\\(undef\\|define\\).*$" "[^\\]$" define) ;preprocessor
	("^#.*$" nil include)                               ; ditto
	;; function decls are expected to have types on the previous line
	("^\\(\\(\\w\\|[$_]\\)+::\\)?\\(\\w\\|[$_]\\)+\\s *\\(\\(\\w\\|[$_]\\)+\\s *((\\|(\\)[^)]*)+" nil defun)
	("^\\(\\(\\w\\|[$_]\\)+[ \t]*::[ \t]*\\)?\\(\\(\\w\\|[$_]\\)+\\|operator.*\\)\\s *\\(\\(\\w\\|[$_]\\)+\\s *((\\|(\\)[^)]*)+" nil defun)
	("^\\(template\\|typedef\\|struct\\|union\\|class\\|enum\\|public\\|private\\|protected\\).*$" nil decl)
	;; datatype -- black magic regular expression
	;; \\(\\w\\|[$_]\\)+_t is removed by HiK. <1999/01/28>
	("[ \n\t({]\\(\\(const\\|register\\|volatile\\|unsigned\\|extern\\|static\\)\\s +\\)*\\(float\\|double\\|void\\|char\\|short\\|int\\|long\\|Integer\\|Real\\|Complex\\|String\\|Matrix\\|Array\\|Index\\|Polynomial\\|CoPolynomial\\|Rational\\|CoRational\\|List\\|CoMatrix\\|PoMatrix\\|RaMatrix\\|CoArray\\|PoArray\\|RaArray\\|FILE\\|\\(\\(struct\\|union\\|enum\\|class\\)\\([ \t]+\\(\\w\\|[$_]\\)*\\)\\)\\)\\(\\s +\\*+)?\\|[ \n\t;()]\\)" nil type)
	;; key words
	("[^_]\\<\\(return\\|goto\\|if\\|else\\|case\\|default\\|switch\\|break\\|continue\\|while\\|do\\|for\\|Func\\|print\\|read\\|public\\|protected\\|private\\|delete\\|new\\)\\>[^_]"
	 1 keyword)))))


;; Contributed by Yasuaki Taniguchi <yasuaki@MaTX.ORG>. <1999/08/10>
;; ported from c-mode and c++-mode sections in font-lock.el of xemacs-21.1.4.
(if (featurep 'xemacs)
    (progn
      (defconst matx-font-lock-keywords-1 nil
	"Subdues level highlighting for MaTX modes.")
      (defconst matx-font-lock-keywords-2 nil
	"Medium level highlighting for MaTX modes.")
      (defconst matx-font-lock-keywords-3 nil
	"Gaudy level highlighting for MaTX modes.")
      (let (
	    (matx-keywords
	     (concat "Func\\|break\\|c\\(lear\\|ontinue\\)\\|do\\|else\\|"
		     "for\\|if\\|p\\(ause\\|rint\\)\\|re\\(ad\\|turn\\)\\|"
		     "switch\\|while"))

	    (matx-type-types
	     (concat "Array\\|Complex\\|In\\(dex\\|teger\\)\\|"
		     "List\\|Matrix\\|Polynomial\\|R\\(ational\\|eal\\)\\|"
		     "\\(Co\\|Po\\|Ra\\)\\(Matrix\\|Array\\)\\|"
		     ;; inserted above by HiK. <1999/08/10>
		     "Co\\(Polynomial\\|Rational\\)\\|"
		     ;; inserted above by HiK. <1999/08/11>
		     "String\\|extern\\|static\\|void"))

	    (matxtoken "\\(\\sw\\|\\s_\\|[:~*&]\\)+")
	    )
	(setq matx-font-lock-keywords-1
	      (list
	       (list (concat
		      "^\\("
		      "\\(" matxtoken "[ \t]+\\)"; type specs; there can be no
		      "\\("
		      "\\(" matxtoken "[ \t]+\\)"; more than 3 tokens, right?
		      "\\(" matxtoken "[ \t]+\\)"
		      "?\\)?\\)?"
;		     "\\([*&]+[ \t]*\\)?"		; pointer
		      "\\(" matxtoken "\\)[ \t]*(")	; name
		     9 'font-lock-function-name-face)
;		    10 'font-lock-function-name-face)


; As no typedef, struct, etc. exist...
;   (list (concat "^\\(typedef[ \t]+struct\\|struct\\|static[ \t]+struct\\)"
;      	   "[ \t]+\\(" ctoken "\\)[ \t]*\\(\{\\|$\\)")
;         2 'font-lock-function-name-face)

	       ;; Fontify case clauses.  This is fast because its anchored on the left.
	       '("case[ \t]+\\(\\(\\sw\\|\\s_\\)+\\)[ \t]+:". 1)
	       '("\\<\\(default\\):". 1)
	       ;; Fontify filenames in #include <...> preprocessor directives as strings.
	       '("^#[ \t]*include[ \t]+\\(<[^>\"\n]+>\\)" 1 font-lock-string-face)
	       ;;
	       ;; Fontify function macro names.
	       '("^#[ \t]*define[ \t]+\\(\\(\\sw+\\)(\\)" 2 font-lock-function-name-face)
	       ;;
	       ;; Fontify symbol names in #if ... defined preprocessor directives.
	       '("^#[ \t]*if\\>"
		 ("\\<\\(defined\\)\\>[ \t]*(?\\(\\sw+\\)?" nil nil
		  (1 font-lock-preprocessor-face) (2 font-lock-variable-name-face nil t)))
	       ;;
	       ;; Fontify symbol names in #elif ... defined preprocessor directives.
	       '("^#[ \t]*elif\\>"
		 ("\\<\\(defined\\)\\>[ \t]*(?\\(\\sw+\\)?" nil nil
		  (1 font-lock-preprocessor-face) (2 font-lock-variable-name-face nil t)))
	       ;;
	       ;; Fontify otherwise as symbol names, and the preprocessor directive names.
	       '("^\\(#[ \t]*[a-z]+\\)\\>[ \t]*\\(\\sw+\\)?"
		 (1 font-lock-preprocessor-face) (2 font-lock-variable-name-face nil t))
	       ))

	(setq matx-font-lock-keywords-2
	      (append matx-font-lock-keywords-1
		      (list
		       ;;
		       ;; Simple regexps for speed.
		       ;;
		       ;; Fontify all type specifiers.
		       (cons (concat "\\<\\(" matx-type-types "\\)\\>")
			     'font-lock-type-face)
		       ;;
		       ;; Fontify all builtin keywords (except case, default and goto; see below).
		       (cons (concat "\\<\\(" matx-keywords "\\)\\>")
			     'font-lock-keyword-face)
		       ;;
		       ;; Fontify case/goto keywords and targets, and case default/goto tags.
;    '("\\<\\(case\\|goto\\)\\>[ \t]*\\([^ \t\n:;]+\\)?"
		       '("\\<\\(case\\)\\>[ \t]*\\([^ \t\n:;]+\\)?"
			 (1 font-lock-keyword-face) (2 font-lock-reference-face nil t))
		       '("^[ \t]*\\(\\sw+\\)[ \t]*:" 1 font-lock-reference-face)
		       )))

	(setq matx-font-lock-keywords-3
	      (append matx-font-lock-keywords-2
		      ;;
		      ;; More complicated regexps for more complete highlighting for types.
		      ;; We still have to fontify type specifiers individually, as C is so hairy.
		      (list
		       ;;
		       ;; Fontify all storage classes and type specifiers, plus their items.
		       (list (concat "\\<\\(" matx-type-types "\\)\\>"
				     "\\([ \t*&]+\\sw+\\>\\)*")
			     ;; Fontify each declaration item.
			     '(font-lock-match-c++-style-declaration-item-and-skip-to-next
			       ;; Start with point after all type specifiers.
			       (goto-char (or (match-beginning 8) (match-end 1)))
			       ;; Finish with point after first type specifier.
			       (goto-char (match-end 1))
			       ;; Fontify as a variable or function name.
			       (1 (if (match-beginning 4)
				      font-lock-function-name-face
				    font-lock-variable-name-face))))
		       ;;
		       ;; Fontify structures, or typedef names, plus their items.
		       '("\\(}\\)[ \t*]*\\sw"
			 (font-lock-match-c++-style-declaration-item-and-skip-to-next
			  (goto-char (match-end 1)) nil
			  (1 (if (match-beginning 4)
				 font-lock-function-name-face
			       font-lock-variable-name-face))))
		       ;;
		       ;; Fontify anything at beginning of line as a declaration or definition.
		       '("^\\(\\sw+\\)\\>\\([ \t*]+\\sw+\\>\\)*"
			 (1 font-lock-type-face)
			 (font-lock-match-c++-style-declaration-item-and-skip-to-next
			  (goto-char (or (match-beginning 2) (match-end 1))) nil
			  (1 (if (match-beginning 4)
				 font-lock-function-name-face
			       font-lock-variable-name-face))))
		       ))))

      (defvar matx-font-lock-keywords matx-font-lock-keywords-1
	"Default expressoins to highlight in MaTX mode.")
      (put 'matx-mode 'font-lock-defaults
	   '((matx-font-lock-keywords
	      matx-font-lock-keywords-1
	      matx-font-lock-keywords-2
	      matx-font-lock-keywords-3)
	     nil nil ((?_ . "w")) beginning-of-defun))
      ))


;;; In the page above, various emacs version-dependent settings for hilit'ing
;;; MaTX code are written. (<- bad doc, isn't it? B)
;;; This page is the main section of matx-mode.el.

(defvar matx-scan-lists-bug-exists nil ;; (Apparently) coded by HiK.
  "Set t if you want some characters to be escaped, or backslashified,
in comment regions.  It is a workaround for some bug in scan-lists function
in some versions of emacs.")

(defvar matx-mode-abbrev-table nil
  "Abbrev table in use in MaTX-mode buffers.")
(define-abbrev-table 'matx-mode-abbrev-table ())

(defvar matx-mode-map ()
  "Keymap used in MaTX mode.")
(if matx-mode-map
    ()
  (setq matx-mode-map (make-sparse-keymap))
  (define-key matx-mode-map "\C-j"      'reindent-then-newline-and-indent)
  (define-key matx-mode-map "{"         'matx-electric-brace)
  (define-key matx-mode-map "}"         'matx-electric-brace)
  (define-key matx-mode-map ";"         'matx-electric-semi)
  (define-key matx-mode-map "\e\C-h"    'mark-matx-function)
  (define-key matx-mode-map "\e\C-q"    'matx-indent-exp)
  (define-key matx-mode-map "\177"      'backward-delete-char-untabify)
  (define-key matx-mode-map "\t"        'matx-indent-command)
  (define-key matx-mode-map "\C-c\C-i"  'matx-insert-header)
  (define-key matx-mode-map "\C-c\C-\\" 'matx-macroize-region)
  (define-key matx-mode-map "\C-c\C-c"  'matx-comment-region)
  (define-key matx-mode-map "\C-c\C-u"  'matx-uncomment-region)
  (define-key matx-mode-map "\e\C-a"    'matx-beginning-of-defun)
  (define-key matx-mode-map "\e\C-e"    'matx-end-of-defun)
  (define-key matx-mode-map "\e\C-x"    'matx-indent-defun)
  (define-key matx-mode-map "/"         'matx-electric-slash)
  (define-key matx-mode-map "*"         'matx-electric-star)
  (define-key matx-mode-map ":"         'matx-electric-colon)
  (define-key matx-mode-map "\177"      'matx-electric-delete)
  (define-key matx-mode-map "\C-c\C-t"  'matx-toggle-auto-hungry-state)
  (define-key matx-mode-map "\C-c\C-h"  'matx-toggle-hungry-state)
  (define-key matx-mode-map "\C-c\C-a"  'matx-toggle-auto-state)
  (define-key matx-mode-map "\C-c'"     'matx-tame-comments)
  (define-key matx-mode-map "'"         'matx-tame-insert)
  (define-key matx-mode-map "["         'matx-tame-insert)
  (define-key matx-mode-map "]"         'matx-tame-insert)
  (define-key matx-mode-map "("         'matx-tame-insert)
  (define-key matx-mode-map ")"         'matx-tame-insert)
  (define-key matx-mode-map "\C-cb"     'matx-submit-bug-report)

;; key mapping for functions of matx-program.el
  (define-key matx-mode-map "\C-c\C-e"  'send-line-to-matx)
  (define-key matx-mode-map "\C-c\C-r"  'send-region-to-matx)

  (define-key matx-mode-map [menu-bar] (make-sparse-keymap))
  (define-key matx-mode-map [menu-bar matx]
    (cons "MaTX" (make-sparse-keymap "MaTX")))

  (define-key matx-mode-map [menu-bar matx matx-uncomment-region]
    '("Un-Comment Out Region" . matx-uncomment-region))
  (define-key matx-mode-map [menu-bar matx matx-comment-region]
    '("Comment Out Region" . matx-comment-region))
  (define-key matx-mode-map [menu-bar matx matx-backslashify-current-line]
    '("Backslashify A Line" . matx-backslashify-current-line))
  (define-key matx-mode-map [menu-bar matx matx-indent-exp]
    '("Indent Expression" . matx-indent-exp))
  )

(defvar matx-mode-syntax-table nil
  "Syntax table in use in MaTX-mode buffers.")

(if matx-mode-syntax-table
    ()
  (setq matx-mode-syntax-table (copy-syntax-table c-mode-syntax-table))
;  (modify-syntax-entry ?/  ". 124" matx-mode-syntax-table)
;  (modify-syntax-entry ?*  ". 23b" matx-mode-syntax-table)
;  (modify-syntax-entry ?\n ">"     matx-mode-syntax-table)
;  (modify-syntax-entry ?'  "'"     matx-mode-syntax-table)

  ;; from cc-mode-5.25. XEmacs can't define syntax properly if 
  ;; above syntax-entry. Add by Taniguchi Yasuaki <1999.10.23>

  ;; Set up block and line oriented comments.  The new C standard
  ;; mandates both comment styles even in C, so since all languages
  ;; now require dual comments, we make this the default.
  (cond
   ;; XEmacs 19 & 20
   ((memq '8-bit c-emacs-features)
    (modify-syntax-entry ?/  ". 1456" matx-mode-syntax-table)
    (modify-syntax-entry ?*  ". 23"   matx-mode-syntax-table))
   ;; Emacs 19 & 20
   ((memq '1-bit c-emacs-features)
    (modify-syntax-entry ?/  ". 124b" matx-mode-syntax-table)
    (modify-syntax-entry ?*  ". 23"   matx-mode-syntax-table))
   ;; incompatible
   (t (error "CC Mode is incompatible with this version of Emacs"))
   )
  (modify-syntax-entry ?\n "> b"  matx-mode-syntax-table)
  ;; Give CR the same syntax as newline, for selective-display
  (modify-syntax-entry ?\^m "> b" matx-mode-syntax-table)
)

; Added by KIYOTA Hiromitsu, these are basic(i.e. K&R style B-).
(defvar matx-brace-offset 0
  "*Extra indentation for braces, compared with other text in same context.")
(defvar matx-indent-level 5  ;2
  "*Indentation of MaTX statements with respect to containing block.")
(defvar matx-argdecl-indent 5
  "*Indentation level of declarations of MaTX function arguments.")
(defvar matx-continued-statement-offset 5  ;2
  "*Extra indent for lines not starting new statements.")
(defvar matx-continued-brace-offset -5  ;0
  "*Extra indent for substatements that start with open-braces.
This is in addition to matx-continued-statement-offset.")
(defvar matx-brace-imaginary-offset 0  ;5
  "*Imagined indentation of a MaTX open brace that actually follows a statement.")
(defvar matx-label-offset -5  ;-2
  "*Offset of MaTX label lines and case statements relative to usual indentation.")

(defvar matx-tab-always-indent
  (if (boundp 'matx-tab-always-indent) matx-tab-always-indent t)
  "*Controls the operation of the TAB key.
t means always just reindent the current line.  nil means indent the
current line only if point is at the left margin or in the line's
indentation; otherwise insert a tab.  If not-nil-or-t, then the line
is first reindented, then if the indentation hasn't changed, a tab is
inserted. This last mode is useful if you like to add tabs after the #
of preprocessor commands.")
(defvar matx-block-close-brace-offset 0
  "*Extra indentation given to close braces which close a block. This
does not affect braces which close a top-level construct (e.g. function).")
(defvar matx-continued-member-init-offset nil
  "*Extra indent for continuation lines of member inits; NIL means to align
with previous initializations rather than with the colon on the first line.")
(defvar matx-member-init-indent 0
  "*Indentation level of member initializations in function declarations.")
(defvar matx-friend-offset -4
  "*Offset of MaTX friend class declarations relative to member declarations.")
(defvar matx-empty-arglist-indent nil
  "*Indicates how far to indent an line following an empty argument
list.  Nil indicates to just after the paren.")
(defvar matx-comment-only-line-offset 0  ;;4  <15 Feb 1995>
  "*Indentation offset for line which contains only C or C++ style comments.")
(defvar matx-cleanup-}-else-{-p t
  "*Controls whether } else { style should remain on a single line.
When t, cleans up this style (when only whitespace intervenes).")
(defvar matx-hanging-braces t
  "*Controls the insertion of newlines before open (left) braces.
This variable only has effect when auto-newline is on.  If nil, open
braces do not hang (i.e. a newline is inserted before all open
braces).  If t, all open braces hang -- no newline is inserted before
open braces.  If not nil or t, newlines are only inserted before
top-level open braces; all other braces hang.")
(defvar matx-hanging-member-init-colon t
  "*If non-nil, don't put a newline after member initialization colon.")
(defvar matx-mode-line-format
  '("" mode-line-modified
    mode-line-buffer-identification
    "   " global-mode-string "   %[("
    mode-name (matx-hungry-delete-key
	       (matx-auto-newline "/ah" "/h")
	       (matx-auto-newline "/a"))
    minor-mode-alist "%n"
    mode-line-process
    ")%]----" (-3 . "%p") "-%-")
  "*Mode line format for matx-mode.")

(defvar matx-auto-hungry-initial-state 'none
  "*Initial state of auto/hungry mode when buffer is first visited.
Legal values are:
     'none         -- no auto-newline and no hungry-delete-key.
     'auto-only    -- auto-newline, but no hungry-delete-key.
     'hungry-only  -- no auto-newline, but hungry-delete-key.
     'auto-hungry  -- both auto-newline and hungry-delete-key enabled.
Nil is synonymous for 'none and t is synonymous for 'auto-hungry.")

(defvar matx-auto-hungry-toggle t
  "*Enable/disable toggling of auto/hungry states.
Legal values are:
     'none         -- auto-newline and hungry-delete-key cannot be enabled.
     'auto-only    -- only auto-newline state can be toggled.
     'hungry-only  -- only hungry-delete-key state can be toggled.
     'auto-hungry  -- both auto-newline and hungry-delete-key can be toggled.
Nil is synonymous for 'none and t is synonymous for 'auto-hungry.")

(defvar matx-hungry-delete-key nil
  "Internal state of hungry delete key.")
(defvar matx-auto-newline nil
  "Internal state of auto newline feature.")

(make-variable-buffer-local 'matx-auto-newline)
(make-variable-buffer-local 'matx-hungry-delete-key)

(defvar matx-mailer 'mail
  "*Mail package to use to generate bug report mail buffer.")
(defconst matx-mode-help-address "MaTX@MaTX.ORG"
  "Address accepting submission of bug reports.")

(defun matx-mode ()
  "Major mode for editing MaTX code.  $Revision: 1.25 $
Do a \"\\[describe-function] matx-dump-state\" for information on
submitting bug reports.

1. Very much like editing C and C++ code.
2. Expression and list commands understand all MaTX brackets.
3. Tab at left margin indents for MaTX code
4. Comments are delimited with /* ... */ {or with // ... <newline>}
5. Paragraphs are separated by blank lines only.
6. Delete converts tabs to spaces as it moves back.

Key bindings:
\\{matx-mode-map}

These variables control indentation style.  Almost all of variables
are inherited from C/C++-mode.

 matx-indent-level
    Indentation of MaTX statements within surrounding block.
    The surrounding block's indentation is the indentation
    of the line on which the open-brace appears.
 matx-continued-statement-offset
    Extra indentation given to a substatement, such as the
    then-clause of an if or body of a while.
 matx-continued-brace-offset
    Extra indentation given to a brace that starts a substatement.
    This is in addition to matx-continued-statement-offset.
 matx-brace-offset
    Extra indentation for line if it starts with an open brace.
 matx-brace-imaginary-offset
    An open brace following other text is treated as if it were
    this far to the right of the start of its line.
 matx-argdecl-indent
    Indentation level of declarations of MaTX function arguments.
 matx-label-offset
    Extra indentation for line that is a label, or case or ``default:'', or
    ``public:'' or ``private:'', or ``protected:''.

 matx-tab-always-indent
    Controls the operation of the TAB key.  t means always just
    reindent the current line.  nil means indent the current line only
    if point is at the left margin or in the line's indentation;
    otherwise insert a tab.  If not-nil-or-t, then the line is first
    reindented, then if the indentation hasn't changed, a tab is
    inserted. This last mode is useful if you like to add tabs after
    the # of preprocessor commands. Default is value for
    matx-tab-always-indent.
 matx-block-close-brace-offset
    Extra indentation give to braces which close a block. This does
    not affect braces which close top-level constructs (e.g. functions).
 matx-continued-member-init-offset
    Extra indentation for continuation lines of member initializations; nil
    means to align with previous initializations rather than with the colon.
 matx-member-init-indent
    Indentation level of member initializations in function declarations,
    if they are on a separate line beginning with a colon.
 matx-empty-arglist-indent
    If non-nil, a function declaration or invocation which ends a line with a
    left paren is indented this many extra spaces, instead of flush with the
    left paren. If nil, it lines up with the left paren.
 matx-comment-only-line-offset
    Extra indentation for a line containing only a C or C++ style comment.
 matx-cleanup-}-else-{-p
    Controls whether } else { style (with only whitespace intervening)
    should be cleaned up so that it sits on only a single line.
 matx-hanging-braces
    Controls open brace hanging behavior when using auto-newline. Nil
    says no braces hang, t says all open braces hang. Not nil or t
    means top-level open braces don't hang, all others do.
 matx-hanging-member-init-colon
    If non-nil and auto-newline is on, newlines are not inserted after
    member initialization colons.
 matx-mode-line-format
    Mode line format for matx-mode buffers. Includes auto-newline and
    hungry-delete-key indicators.
 matx-auto-hungry-initial-state
    Initial state of auto/hungry mode when a MaTX buffer is first visited.
 matx-auto-hungry-toggle
    Enable/disable toggling of auto/hungry states.

Auto-newlining is no longer an all or nothing proposition. To be
specific I don't believe it is possible to implement a perfect
auto-newline algorithm. Sometimes you want it and sometimes you don't.
So now auto-newline (and its companion, hungry-delete) can be toggled
on and off on the fly.  Hungry-delete is the optional behavior of the
delete key. When hungry-delete is enabled, hitting the delete key
once consumes all preceeding whitespace, unless point is within a
literal (defined as a C or C++ comment, or string).  Inside literals,
and with hungry-delete disabled, the delete key just calls
backward-delete-char-untabify.

Behavior is controlled by matx-auto-hungry-initial-state and
matx-auto-hungry-toggle.  Legal values for both variables are:

   'none (or nil)      -- no auto-newline or hungry-delete.
   'auto-only          -- function affects only auto-newline state.
   'hungry-only        -- function affects only hungry-delete state.
   'auto-hungry (or t) -- function affects both states.

Thus if matx-auto-hungry-initial-state is 'hungry-only, then only
hungry state is turned on when the buffer is first visited.  If
matx-auto-hungry-toggle is 'auto-hungry, and both auto-newline and
hungry-delete state are on, then hitting \"\\[matx-toggle-auto-hungry-state]\"
will toggle both states.  Hitting \"\\[matx-toggle-hungry-state]\" will
always toggle hungry-delete state and hitting \"\\[matx-toggle-auto-state]\"
will always toggle auto-newline state, regardless of the value of
matx-auto-hungry-toggle.   Hungry-delete state, when on, makes the
delete key consume all preceding whitespace.

Settings for K&R, BSD, Stroustrup, and GNU-like indentation styles are
  matx-indent-level                5    8    4    2
  matx-continued-statement-offset  5    8    4    2
  matx-continued-brace-offset                0    0
  matx-brace-offset               -5   -8    0    0
  matx-brace-imaginary-offset                0    0
  matx-argdecl-indent              0    8    4    5
  matx-label-offset               -5   -8   -4   -2
  matx-empty-arglist-indent                  4
  matx-friend-offset                         0

Turning on MaTX mode calls the value of the variable matx-mode-hook with
no args, if that value is non-nil."
  (interactive)
  (kill-all-local-variables)
  (use-local-map matx-mode-map)
  (set-syntax-table matx-mode-syntax-table)
  (setq major-mode 'matx-mode
	mode-name "MaTX"
	local-abbrev-table matx-mode-abbrev-table)
  (set (make-local-variable 'paragraph-start) (concat "^$\\|" page-delimiter))
  (set (make-local-variable 'paragraph-separate) paragraph-start)
  (set (make-local-variable 'paragraph-ignore-fill-prefix) t)
  (set (make-local-variable 'require-final-newline) t)
  (set (make-local-variable 'parse-sexp-ignore-comments) nil)
  ;; 
  (set (make-local-variable 'indent-line-function) 'matx-indent-line)
  (set (make-local-variable 'comment-start) "// ")
  (set (make-local-variable 'comment-end) "")
  (set (make-local-variable 'comment-column) 32)
  (set (make-local-variable 'comment-start-skip) "/\\*+ *\\|// *")
  (set (make-local-variable 'comment-indent-hook) 'matx-comment-indent)
  ;;
;  (setq mode-line-format matx-mode-line-format)
  (run-hooks 'matx-mode-hook)
  (matx-set-auto-hungry-state
   (memq matx-auto-hungry-initial-state '(auto-only   auto-hungry t))
   (memq matx-auto-hungry-initial-state '(hungry-only auto-hungry t))))

(defun matx-comment-indent ()
  "Used by indent-for-comment to decide how much to indent a comment
in MaTX code based on its context."
  (if (looking-at "^\\(/\\*\\|//\\)")
      0					; Existing comment at bol stays there.
    (save-excursion
      (skip-chars-backward " \t")
      (max
       ;; leave at least one space on non-empty lines.
       (if (zerop (current-column)) 0 (1+ (current-column)))
       (let ((cur-pt (point)))
	 (beginning-of-line 0)
	 ;; If previous line had a comment, use it's indent
	 (if (re-search-forward comment-start-skip cur-pt t)
	     (progn
	       (goto-char (match-beginning 0))
	       (current-column))
	   comment-column))))))		; otherwise indent at comment column.

(defun matx-set-auto-hungry-state (auto-p hungry-p)
  "Set auto/hungry to state indicated by AUTO-P and HUNGRY-P.
Update mode line to indicate state to user."
  (setq matx-auto-newline auto-p
	matx-hungry-delete-key hungry-p)
  (set-buffer-modified-p (buffer-modified-p)))

(defun matx-toggle-auto-state (arg)
  "Toggle auto-newline state.
This function ignores matx-auto-hungry-toggle variable.  Optional
numeric ARG, if supplied turns on auto-newline when positive, turns
off auto-newline when negative and toggles when zero."
  (interactive "P")
  (let ((auto (cond ((not arg)
		     (not matx-auto-newline))
		    ((zerop (setq arg (prefix-numeric-value arg)))
		     (not matx-auto-newline))
		    ((< arg 0) nil)
		    (t t))))
    (matx-set-auto-hungry-state auto matx-hungry-delete-key)))

(defun matx-toggle-hungry-state (arg)
  "Toggle hungry-delete-key state.
This function ignores matx-auto-hungry-toggle variable.  Optional
numeric ARG, if supplied turns on hungry-delete-key when positive,
turns off hungry-delete-key when negative and toggles when zero."
  (interactive "P")
  (let ((hungry (cond ((not arg)
		       (not matx-hungry-delete-key))
		      ((zerop (setq arg (prefix-numeric-value arg)))
		       (not matx-hungry-delete-key))
		      ((< arg 0) nil)
		      (t t))))
    (matx-set-auto-hungry-state matx-auto-newline hungry)))

(defun matx-toggle-auto-hungry-state (arg)
  "Toggle auto-newline and hungry-delete-key state.
Actual toggling of these states is controlled by
matx-auto-hungry-toggle variable.

Optional argument has the following meanings when supplied:
     Universal argument \\[universal-argument]
          resets state to matx-auto-hungry-initial-state.
     negative number
          turn off both auto-newline and hungry-delete-key.
     positive number
          turn on both auto-newline and hungry-delete-key.
     zero
          toggle both states regardless of matxauto-hungry-toggle-p."
  (interactive "P")
  (let* ((numarg (prefix-numeric-value arg))
	 (apl (list 'auto-only   'auto-hungry t))
	 (hpl (list 'hungry-only 'auto-hungry t))
	 (auto (cond ((not arg)
		      (if (memq matx-auto-hungry-toggle apl)
			  (not matx-auto-newline)
			matx-auto-newline))
		     ((listp arg)
		      (memq matx-auto-hungry-initial-state apl))
		     ((zerop numarg)
		      (not matx-auto-newline))
		     ((< arg 0) nil)
		     (t t)))
	 (hungry (cond ((not arg)
			(if (memq matx-auto-hungry-toggle hpl)
			    (not matx-hungry-delete-key)
			  matx-hungry-delete-key))
		       ((listp arg)
			(memq matx-auto-hungry-initial-state hpl))
		       ((zerop numarg)
			(not matx-hungry-delete-key))
		       ((< arg 0) nil)
		       (t t))))
    (matx-set-auto-hungry-state auto hungry)))

(defun matx-tame-insert (arg)
  "Safely inserts certain troublesome characters in comment regions.
Because of a syntax bug in emacs' scan-lists function, characters with
string or parenthesis syntax must be escaped with a backslash or lots
of things get messed up. Unfortunately, setting
parse-sexp-ignore-comments to non-nil does not fix the problem."
  (interactive "p")
  (if (and matx-scan-lists-bug-exists
	   (matx-in-comment-p))
      (insert "\\"))
  (self-insert-command arg))

(defun matx-electric-delete (arg)
  "If matx-hungry-delete-key is non-nil, consumes all preceding
whitespace unless ARG is supplied, or point is inside a C or C++ style
comment or string.  If ARG is supplied, this just calls
backward-delete-char-untabify passing along ARG.

If matx-hungry-delete-key is nil, just call
backward-delete-char-untabify."
  (interactive "P")
  (cond
   ((or (not matx-hungry-delete-key) arg)
    (backward-delete-char-untabify (prefix-numeric-value arg)))
   ((not (or (matx-in-comment-p)
	     (matx-in-open-string-p)))
    (let ((here (point)))
      (skip-chars-backward "[ \t\n]")
      (if (/= (point) here)
	  (delete-region (point) here)
	(backward-delete-char-untabify 1))))
   (t (backward-delete-char-untabify 1))))

(defun matx-electric-brace (arg)
  "Insert character and correct line's indentation."
  (interactive "P")
  (let (insertpos (last-command-char last-command-char))
    (if (and (not arg)
	     (eolp)
	     (or (save-excursion
		   (skip-chars-backward " \t")
		   (bolp))
		 (let ((matx-auto-newline matx-auto-newline)
		       (open-brace-p (= last-command-char ?{)))
		   (if (and open-brace-p
			    (or (eq matx-hanging-braces t)
				(and matx-hanging-braces
				     (not (matx-at-top-level-p)))))
		       (setq matx-auto-newline nil))
		   (matx-auto-newline)
		   ;; this may have auto-filled so we need to indent
		   ;; the previous line
		   (save-excursion
		     (forward-line -1)
		     (matx-indent-line))
		   t)))
	(progn
	  (if (and matx-scan-lists-bug-exists
		   (matx-in-comment-p))
	      (insert "\\"))
	  (insert last-command-char)
	  (let ((here (make-marker)) mbeg mend)
	    (set-marker here (point))
	    (if (and matx-cleanup-}-else-{-p
		     (= last-command-char ?\{)
		     (let ((status (re-search-backward "}[ \t\n]*else[ \t\n]*{"
						       nil t)))
		       (setq mbeg (match-beginning 0)
			     mend (match-end 0))
		       status)
		     (not (matx-in-open-string-p))
		     (not (matx-in-comment-p)))
		(progn
		  ;; we should clean up brace-else-brace syntax
		  (delete-region mbeg mend)
		  (insert-before-markers "} else {")
		  (goto-char here)
		  (set-marker here nil))
	      (goto-char here)
	      (set-marker here nil)))
	  (matx-indent-line)
	  (if (matx-auto-newline)
	      (progn
		;; matx-auto-newline may have done an auto-fill
		(save-excursion
		  (let ((here (make-marker)))
		    (set-marker here (point))
		    (goto-char (- (point) 2))
		    (matx-indent-line)
		    (setq insertpos (- (goto-char here) 2))
		    (set-marker here nil)))
		(matx-indent-line)))
	  (save-excursion
	    (if insertpos (goto-char (1+ insertpos)))
	    (delete-char -1))))
    (if insertpos
	(save-excursion
	  (goto-char insertpos)
	  (self-insert-command (prefix-numeric-value arg)))
      (self-insert-command (prefix-numeric-value arg)))))

(defun matx-electric-slash (arg)
  "Slash as first non-whitespace character on line indents as comment
unless we're inside a C style comment, or a string, does not do
indentation. if first non-whitespace character on line is not a slash,
then we just insert the slash.  in this case use indent-for-comment if
you want to add a comment to the end of a line."
  (interactive "P")
  (let ((matx-auto-newline matx-auto-newline))
    (if (= (preceding-char) ?/)
	(setq matx-auto-newline nil))
    (if (memq (preceding-char) '(?/ ?*))
	(matx-electric-terminator arg)
      (self-insert-command (prefix-numeric-value arg)))))

(defun matx-electric-star (arg)
  "Works with matx-electric-slash to auto indent C style comment lines."
  (interactive "P")
  (if (= (preceding-char) ?/)
      (let ((matx-auto-newline nil))
	(matx-electric-terminator arg))
    (self-insert-command (prefix-numeric-value arg))))

(defun matx-electric-semi (arg)
  "Insert character and correct line's indentation."
  (interactive "P")
  (let ((insertion-point (point)))
    (save-excursion
      (skip-chars-backward " \t\n")
      (if (= (preceding-char) ?})
	  (delete-region insertion-point (point)))))
  (matx-electric-terminator arg))

(defun matx-electric-colon (arg)
  "Electrify colon.  De-auto-newline double colons. No auto-new-lines
for member initialization list."
  (interactive "P")
  (let ((matx-auto-newline matx-auto-newline)
	(insertion-point (point)))
    (save-excursion
      (skip-chars-backward " \t\n")
      (if (= (preceding-char) ?:)	;check for double colon
	  (progn
	    (delete-region insertion-point (point))
	    (setq matx-auto-newline nil)))
      (if (and matx-hanging-member-init-colon
	       (progn (matx-backward-to-noncomment (point-min))
		      (= (preceding-char) ?\))))
	  (setq matx-auto-newline nil)))
    (matx-electric-terminator arg)))

(defun matx-electric-terminator (arg)
  "Insert character and correct line's indentation."
  (interactive "P")
  (let (insertpos (end (point)))
    (if (and (not arg) (eolp)
	     (not (save-excursion
		    (beginning-of-line)
		    (skip-chars-forward " \t")
		    (or (= (following-char) ?#)
			;; Colon is special only after a label, or
			;; case, or another colon.
			;; So quickly rule out most other uses of colon
			;; and do no indentation for them.
			(and (eq last-command-char ?:)
			     (not (looking-at "case[ \t]"))
			     (save-excursion
			       (forward-word 1)
			       (skip-chars-forward " \t")
			       (< (point) end))
			     ;; Do re-indent double colons
			     (save-excursion
			       (end-of-line 1)
			       (looking-at ":")))
			(progn
			  (beginning-of-defun)
			  (let ((pps (parse-partial-sexp (point) end)))
			    (or (nth 3 pps) (nth 4 pps) (nth 5 pps))))))))
	(progn
	  (insert last-command-char)
	  (matx-indent-line)
	  (and matx-auto-newline
	       (not (matx-in-parens-p))
	       (progn
		 ;; the new marker object, used to be just an integer
		 (setq insertpos (make-marker))
		 ;; changed setq to set-marker
		 (set-marker insertpos (1- (point)))
		 ;; do this before the newline, since in auto fill can break
		 (newline)
		 (matx-indent-line)))
	  (save-excursion
	    (if insertpos (goto-char (1+ insertpos)))
	    (delete-char -1))))
    (if insertpos
	(save-excursion
	  (goto-char insertpos)
	  (self-insert-command (prefix-numeric-value arg)))
      (self-insert-command (prefix-numeric-value arg)))))

(defun matx-indent-command (&optional whole-exp)
  "Indent current line as MaTX code, or in some cases insert a tab character.
If matx-tab-always-indent is t (the default), always just indent the
current line.  If nil, indent the current line only if point is at the
left margin or in the line's indentation; otherwise insert a tab.  If
not-nil-or-t, then tab is inserted only within literals (comments and
strings) and inside preprocessor directives, but line is always reindented.

A numeric argument, regardless of its value, means indent rigidly all
the lines of the expression starting after point so that this line
becomes properly indented.  The relative indentation among the lines
of the expression are preserved."
  (interactive "P")
  (if whole-exp
      ;; If arg, always indent this line as C
      ;; and shift remaining lines of expression the same amount.
      (let ((shift-amt (matx-indent-line))
	    beg end)
	(save-excursion
	  (if (eq matx-tab-always-indent t)
	      (beginning-of-line))
	  (setq beg (point))
	  (forward-sexp 1)
	  (setq end (point))
	  (goto-char beg)
	  (forward-line 1)
	  (setq beg (point)))
	(if (> end beg)
	    (indent-code-rigidly beg end shift-amt "#")))
    (cond ((and (eq matx-tab-always-indent nil)
		(save-excursion
		  (skip-chars-backward " \t")
		  (not (bolp))))
	   (insert-tab))
	  ((eq matx-tab-always-indent t)
	   (matx-indent-line))
	  ((or (matx-in-open-string-p)
	       (matx-in-comment-p)
	       (save-excursion
		 (back-to-indentation)
		 (eq (char-after (point)) ?#)))
	   (let ((boi (save-excursion
		       (back-to-indentation)
		       (point)))
		 (indent-p nil))
	     (matx-indent-line)
	     (save-excursion
	       (back-to-indentation)
	       (setq indent-p (= (point) boi)))
	     (if indent-p (insert-tab))))
	  (t (matx-indent-line)))))

(defun matx-indent-line ()
  "Indent current line as MaTX code.
Return the amount the indentation changed by."
  (let ((indent (matx-calculate-indent nil))
	beg shift-amt
	(comcol nil)
	(case-fold-search nil)
	(pos (- (point-max) (point))))
    (beginning-of-line)
    (setq beg (point))
    (cond ((eq indent nil)
	   (setq indent (current-indentation)))
	  ((eq indent t)
	   (setq indent (calculate-c-indent-within-comment)))
	  ((looking-at "[ \t]*#")
	   (setq indent 0))
	  ((save-excursion
	     (and (not (back-to-indentation))
		  (looking-at "//\\|/\\*")
		  (/= (setq comcol (current-column)) 0)))
	   ;; we've found a comment-only line. we now must try to
	   ;; determine if the line is a continuation from a comment
	   ;; on the previous line.  we check to see if the comment
	   ;; starts in comment-column and if so, we don't change its
	   ;; indentation.
	   (if (= comcol comment-column)
	       (setq indent comment-column)
	     (setq indent (+ indent matx-comment-only-line-offset))))
	  (t
	   (skip-chars-forward " \t")
	   (if (listp indent) (setq indent (car indent)))
	   (cond ((looking-at "\\(default\\|public\\|private\\|protected\\):")
		  (setq indent (+ indent matx-label-offset)))
		 ((or (looking-at "case\\b")
		      (and (looking-at "[A-Za-z]")
			   (save-excursion
			     (forward-sexp 1)
			     (looking-at ":[^:]"))))
		  (setq indent (max 1 (+ indent matx-label-offset))))
		 ((and (looking-at "else\\b")
		       (not (looking-at "else\\s_")))
		  (setq indent (save-excursion
				 (c-backward-to-start-of-if)
				 (current-indentation))))
		 ((looking-at "friend\[ \t]class[ \t]")
		  (setq indent (+ indent matx-friend-offset)))
		 ((= (following-char) ?\))
		  (setq indent (+ (- indent matx-indent-level)
				  (if (save-excursion
					(forward-char 1)
					(matx-at-top-level-p))
				      (- matx-block-close-brace-offset)
				    matx-block-close-brace-offset))))
		 ((= (following-char) ?})
		  (setq indent (+ (- indent matx-indent-level)
				  (if (save-excursion
					(forward-char 1)
					(matx-at-top-level-p))
				      (- matx-block-close-brace-offset)
				    matx-block-close-brace-offset))))
		 ((= (following-char) ?{)
		  (setq indent (+ indent matx-brace-offset))))))
    (skip-chars-forward " \t")
    (setq shift-amt (- indent (current-column)))
    (if (zerop shift-amt)
	(if (> (- (point-max) pos) (point))
	    (goto-char (- (point-max) pos)))
      (delete-region beg (point))
      (indent-to indent)
      ;; If initial point was within line's indentation,
      ;; position after the indentation.  Else stay at same point in text.
      (if (> (- (point-max) pos) (point))
	  (goto-char (- (point-max) pos))))
    shift-amt))

(defun matx-at-top-level-p ()
  "Return t if point is not inside a containing MaTX expression, nil
if it is embedded in an expression."
  ;; hack to work around emacs comment bug
  (save-excursion
    (let ((indent-point (point))
	  (case-fold-search nil)
	  state containing-sexp parse-start)
      (beginning-of-defun)
      (while (< (point) indent-point)
	(setq parse-start (point))
	(setq state (parse-partial-sexp (point) indent-point 0))
	(setq containing-sexp (car (cdr state))))
      (null containing-sexp))))

(defun matx-in-comment-p ()
  "Return t if in a C or C++ style comment as defined by mode's syntax."
  (save-excursion
    (let ((here (point)))
      (beginning-of-defun)
      (nth 4 (parse-partial-sexp (point) here 0)))))

(defun matx-in-open-string-p ()
  "Return non-nil if in an open string as defined by mode's syntax."
  ;; temporarily change tick to string syntax, just for this check
  (save-excursion
    (let* ((here (point)))
      (beginning-of-defun)
      (nth 3 (parse-partial-sexp (point) here 0)))))

(defun matx-in-parens-p ()
  ;; hack to work around emacs comment bug
  (condition-case ()
      (save-excursion
	(save-restriction
	  (narrow-to-region (point)
			    (progn (beginning-of-defun) (point)))
	  (goto-char (point-max))
	  (= (char-after (or (scan-lists (point) -1 1) (point-min))) ?\()))
    (error nil)))

(defun matx-auto-newline ()
  "Insert a newline iff we're not in a literal.
Literals are defined as being inside a C or C++ style comment or open
string according to mode's syntax."
  (and matx-auto-newline
       (not (matx-in-comment-p))
       (not (matx-in-open-string-p))
       (not (newline))))

(defun matx-calculate-indent (&optional parse-start)
  "Return appropriate indentation for current line as MaTX code.
In usual case returns an integer: the column to indent to.
Returns nil if line starts inside a string, t if in a comment."
  (save-excursion
    (beginning-of-line)
    (let ((indent-point (point))
	  (case-fold-search nil)
	  state do-indentation
	  containing-sexp)
      (if parse-start
	  (goto-char parse-start)
	(beginning-of-defun))
      (while (< (point) indent-point)
	(setq parse-start (point))
	(setq state (parse-partial-sexp (point) indent-point 0))
	(setq containing-sexp (car (cdr state))))
      (cond ((nth 3 state)
	     ;; in a string.
	     nil)
	    ((matx-in-comment-p)
	     ;; in a C comment.
	     t)
	    ;; is this a comment-only line in the first column or
	    ;; comment-column?  if so we don't change the indentation,
	    ;; otherwise, we indent relative to surrounding code
	    ;; (later on).
	    ((progn (goto-char indent-point)
		    (beginning-of-line)
		    (skip-chars-forward " \t")
		    (and (looking-at comment-start-skip)
			 (or (zerop (current-column))
			     (= (current-column) comment-column))))
	     (current-column))
	    ((null containing-sexp)
	     ;; Line is at top level.  May be comment-only line, data
	     ;; or function definition, or may be function argument
	     ;; declaration or member initialization.  Indent like the
	     ;; previous top level line unless:
	     ;;
	     ;; 1. the previous line ends in a closeparen without
	     ;; semicolon, in which case this line is the first
	     ;; argument declaration or member initialization, or
	     ;;
	     ;; 2. the previous line ends with a closeparen
	     ;; (closebrace), optional spaces, and a semicolon, in
	     ;; which case this line follows a multiline function
	     ;; declaration (class definition), or
	     ;;
	     ;; 3. the previous line begins with a colon, in which
	     ;; case this is the second line of member inits.  It is
	     ;; assumed that arg decls and member inits are not mixed.
	     ;;
	     (goto-char indent-point)
	     (skip-chars-forward " \t")
	     (if (looking-at "/[/*]")
		 ;; comment only line, but must not be in the first
		 ;; column since cond case above would have caught it
		 0
	       (if (= (following-char) ?{)
		   0   ; Unless it starts a function body
		 (matx-backward-to-noncomment (or parse-start (point-min)))
		 (if (= (preceding-char) ?\))
		     (progn		; first arg decl or member init
		       (goto-char indent-point)
		       (skip-chars-forward " \t")
		       (if (= (following-char) ?:)
			   matx-member-init-indent
			 matx-argdecl-indent))
		   (if (= (preceding-char) ?\;)
		       (progn
			 (backward-char 1)
			 (skip-chars-backward " \t")))
		   (if (or (= (preceding-char) ?})
			   (= (preceding-char) ?\)))
		       0
		     (beginning-of-line) ; continued arg decls or member inits
		     (skip-chars-forward " \t")
		     (if (looking-at "/[/*]")
			 0
		       (if (= (following-char) ?:)
			   (if matx-continued-member-init-offset
			       (+ (current-indentation)
				  matx-continued-member-init-offset)
			     (progn
			       (forward-char 1)
			       (skip-chars-forward " \t")
			       (current-column)))
			 (current-indentation))))
		   ))))
	    ((/= (char-after containing-sexp) ?{)
	     ;; line is expression, not statement:
	     ;; indent to just after the surrounding open -- unless
	     ;; empty arg list, in which case we do what
	     ;; matx-empty-arglist-indent says to do.
	     (if (and matx-empty-arglist-indent
		      (or (null (nth 2 state))	;; indicates empty arg
						;; list.
			  ;; Use a heuristic: if the first
			  ;; non-whitespace following left paren on
			  ;; same line is not a comment,
			  ;; is not an empty arglist.
			  (save-excursion
			    (goto-char (1+ containing-sexp))
			    (not
			     (looking-at "\\( \\|\t\\)*[^/\n]")))))
		 (progn
		   (goto-char containing-sexp)
		   (beginning-of-line)
		   (skip-chars-forward " \t")
		   (goto-char (min (+ (point) matx-empty-arglist-indent)
				   (1+ containing-sexp)))
		   (current-column))
	       ;; In MaTX-mode, we would always indent to one after the
	       ;; left paren.  Here, though, we may have an
	       ;; empty-arglist, so we'll indent to the min of that
	       ;; and the beginning of the first argument.
	       (goto-char (1+ containing-sexp))
	       ;; we want to skip any whitespace b/w open paren and
	       ;; first argurment. this handles while (thing) style
	       ;; and while( thing ) style
	       (skip-chars-forward " \t")
	       (current-column)))
	    (t
	     ;; Statement.  Find previous non-comment character.
	     (goto-char indent-point)
	     (matx-backward-to-noncomment containing-sexp)
	     (if (not (memq (preceding-char) '(nil ?\, ?\; ?} ?: ?\{)))
		 ;; This line is continuation of preceding line's statement;
		 ;; indent  matx-continued-statement-offset  more than the
		 ;; previous line of the statement.
		 (progn
		   (c-backward-to-start-of-continued-exp containing-sexp)
                   (+ (current-column)
                      ;; j.peck hack to prevent repeated continued indentation:
                      (if (save-excursion
                            (beginning-of-line 1)
                            (matx-backward-to-noncomment containing-sexp)
                            (memq (preceding-char) '(nil ?\, ?\; ?} ?: ?\{)))
                          matx-continued-statement-offset
			;; the following statements *do* indent even
			;; for single statements (are there others?)
			(if (looking-at
			     "\\(do\\|else\\|for\\|if\\|while\\)\\b")
			    matx-continued-statement-offset
			  0))
                      ;; j.peck  [8/13/91]
		      ;; j.peck hack replaced this line:
		      ;; \(+ matx-continued-statement-offset (current-column)
		      ;; Add continued-brace-offset? [weikart]
		      (if (save-excursion (goto-char indent-point)
					  (skip-chars-forward " \t")
					  (eq (following-char) ?{))
			  matx-continued-brace-offset 0)))
	       ;; This line may start a new statement, or it could
	       ;; represent the while closure of a do/while construct
	       (if (save-excursion
		     (and
		      (progn
			(goto-char indent-point)
			(skip-chars-forward " \t\n")
			(looking-at "while\\b"))
		      (progn
			(matx-backward-to-start-of-do containing-sexp)
			(looking-at "do\\b"))
		      (setq do-indentation (current-column))))
		   do-indentation
		 ;; this could be a case statement. if so we want to
		 ;; indent it like the first case statement after a switch
		 (if (save-excursion
		       (goto-char indent-point)
		       (skip-chars-forward " \t\n")
		       (looking-at "case\\b"))
		     (progn
		       (goto-char containing-sexp)
		       (back-to-indentation)
		       (+ (current-column) matx-indent-level))
		   ;; else, this is the start of a new statement
		   ;; Position following last unclosed open.
		   (goto-char containing-sexp)
		   ;; Is line first statement after an open-brace?
		   (or
		    ;; If no, find that first statement and indent like it.
		    (save-excursion
		      (forward-char 1)
		      (while (progn (skip-chars-forward " \t\n")
				    (looking-at
				     (concat
				      "#\\|/\\*\\|//"
				      "\\|case[ \t]"
				      "\\|[a-zA-Z0-9_$]*:[^:]"
				      "\\|friend[ \t]class[ \t]")))
			;; Skip over comments and labels following openbrace.
			(cond ((= (following-char) ?\#)
			       (forward-line 1))
			      ((looking-at "/\\*")
			       (search-forward "*/" nil 'move))
			      ((looking-at "//\\|friend[ \t]class[ \t]")
			       (forward-line 1))
			      ((looking-at "case\\b")
			       (forward-line 1))
			      (t
			       (re-search-forward ":[^:]" nil 'move))))
		      ;; The first following code counts
		      ;; if it is before the line we want to indent.
		      (and (< (point) indent-point)
			   (if (save-excursion
				 (progn
				   (goto-char indent-point)
				   (skip-chars-forward " \t")
				   (looking-at "\{")))
			       (progn
				 (- (current-column) matx-brace-offset))
			     (progn
			   (current-column)))))
		    ;; If no previous statement, indent it relative to
		    ;; line brace is on.  For open brace in column
		    ;; zero, don't let statement start there too.  If
		    ;; matx-indent-offset is zero, use matx-brace-offset +
		    ;; matx-continued-statement-offset instead.  For
		    ;; open-braces not the first thing in a line, add
		    ;; in matx-brace-imaginary-offset.
		    (+ (if (and (bolp) (zerop matx-indent-level))
			   (if (save-excursion
				 (progn
				   (goto-char indent-point)
				   (skip-chars-forward " \t")
				   (looking-at "\{")))
			       matx-continued-statement-offset
			     (+ matx-brace-offset matx-continued-statement-offset))
			 (if (save-excursion
			       (progn
				 (goto-char indent-point)
				 (skip-chars-forward " \t")
				 (looking-at "\{")))
			     (- matx-indent-level matx-brace-offset)
			   matx-indent-level))
		       ;; Move back over whitespace before the openbrace.
		       ;; If openbrace is not first nonwhite thing on the line,
		       ;; add the matx-brace-imaginary-offset.
		       (progn (skip-chars-backward " \t")
			      (if (bolp) 0 matx-brace-imaginary-offset))
		       ;; If the openbrace is preceded by a parenthesized exp,
		       ;; move to the beginning of that;
		       ;; possibly a different line
		       (progn
			 (if (eq (preceding-char) ?\))
			     (forward-sexp -1))
			 ;; Get initial indentation of the line we are on.
			 (current-indentation))))))))))))

(defun matx-backward-to-noncomment (lim)
  "Skip backwards to first preceding non-comment character."
  (let (opoint stop)
    (while (not stop)
      (skip-chars-backward " \t\n\r\f" lim)
      (setq opoint (point))
      (cond ((and (>= (point) (+ 2 lim))
		  (save-excursion
		    (forward-char -2)
		    (looking-at "\\*/")))
	     (search-backward "/*" lim 'move))
	    ((and
	      (let ((sblim (max (matx-point-bol) lim)))
		(if (< (point) sblim)
		    nil
		  (search-backward "//" (max (matx-point-bol) lim) 'move)))
	      (not (matx-in-open-string-p))))
	  (t (beginning-of-line)
	     (skip-chars-forward " \t")
	     (if (looking-at "#")
		 (setq stop (<= (point) lim))
	       (setq stop t)
	       (goto-char opoint)))))))

(defun matx-backward-to-start-of-do (&optional limit)
  "Move to the start of the last ``unbalanced'' do."
  (or limit (setq limit (save-excursion (beginning-of-defun) (point))))
  (let ((do-level 1)
	(case-fold-search nil))
    (while (not (zerop do-level))
      ;; we protect this call because trying to execute this when the
      ;; while is not associated with a do will throw an error
      (condition-case err
	  (progn
	    (backward-sexp 1)
	    (cond ((looking-at "while\\b")
		   (setq do-level (1+ do-level)))
		  ((looking-at "do\\b")
		   (setq do-level (1- do-level)))
		  ((< (point) limit)
		   (setq do-level 0)
		   (goto-char limit))))
	(error
	 (goto-char limit)
	 (setq do-level 0))))))

(defun matx-indent-exp ()
  "Indent each line of the MaTX grouping following point."
  (interactive)
  (let ((indent-stack (list nil))
	(contain-stack (list (point)))
	(case-fold-search nil)
	restart outer-loop-done inner-loop-done state ostate
	this-indent last-sexp last-depth
	at-else at-brace
	(opoint (point))
	(next-depth 0))
    (save-excursion
      (forward-sexp 1))
    (save-excursion
      (setq outer-loop-done nil)
      (while (and (not (eobp)) (not outer-loop-done))
	(setq last-depth next-depth)
	;; Compute how depth changes over this line
	;; plus enough other lines to get to one that
	;; does not end inside a comment or string.
	;; Meanwhile, do appropriate indentation on comment lines.
	(setq inner-loop-done nil)
	(while (and (not inner-loop-done)
		    (not (and (eobp) (setq outer-loop-done t))))
	  (setq ostate state)
	  ;; fix by reed@adapt.net.com
	  ;; must pass in the return past the end of line, so that
	  ;; parse-partial-sexp finds it, and recognizes that a "//"
	  ;; comment is over. otherwise, state is set that we're in a
	  ;; comment, and never gets unset, causing outer-loop to only
	  ;; terminate in (eobp). old:
	  ;;(setq state (parse-partial-sexp (point)
	  ;;(progn (end-of-line) (point))
	  ;;nil nil state))
	  (let ((start (point))
		(line-end (progn (end-of-line) (point)))
		(end (progn (forward-char) (point))))
	    (setq state (parse-partial-sexp start end nil nil state))
	    (goto-char line-end))
	  (setq next-depth (car state))
	  (if (and (car (cdr (cdr state)))
		   (>= (car (cdr (cdr state))) 0))
	      (setq last-sexp (car (cdr (cdr state)))))
	  (if (or (nth 4 ostate))
	      (matx-indent-line))
	  (if (or (nth 3 state))
	      (forward-line 1)
	    (setq inner-loop-done t)))
	(if (<= next-depth 0)
	    (setq outer-loop-done t))
	(if outer-loop-done
	    nil
	  ;; If this line had ..))) (((.. in it, pop out of the levels
	  ;; that ended anywhere in this line, even if the final depth
	  ;; doesn't indicate that they ended.
	  (while (> last-depth (nth 6 state))
	    (setq indent-stack (cdr indent-stack)
		  contain-stack (cdr contain-stack)
		  last-depth (1- last-depth)))
	  (if (/= last-depth next-depth)
	      (setq last-sexp nil))
	  ;; Add levels for any parens that were started in this line.
	  (while (< last-depth next-depth)
	    (setq indent-stack (cons nil indent-stack)
		  contain-stack (cons nil contain-stack)
		  last-depth (1+ last-depth)))
	  (if (null (car contain-stack))
	      (setcar contain-stack (or (car (cdr state))
					(save-excursion (forward-sexp -1)
							(point)))))
	  (forward-line 1)
	  (skip-chars-forward " \t")
	  (if (eolp)
	      nil
	    (if (and (car indent-stack)
		     (>= (car indent-stack) 0))
		;; Line is on an existing nesting level.
		;; Lines inside parens are handled specially.
		(if (/= (char-after (car contain-stack)) ?{)
		    (setq this-indent (car indent-stack))
		  ;; Line is at statement level.
		  ;; Is it a new statement?  Is it an else?
		  ;; Find last non-comment character before this line
		  (save-excursion
		    (setq at-else (looking-at "else\\W"))
		    (setq at-brace (= (following-char) ?{))
		    (matx-backward-to-noncomment opoint)
		    (if (not (memq (preceding-char) '(nil ?\, ?\; ?} ?: ?{)))
			;; Preceding line did not end in comma or semi;
			;; indent this line  matx-continued-statement-offset
			;; more than previous.
			(progn
			  (c-backward-to-start-of-continued-exp
			   (car contain-stack))
			  (setq this-indent
				(+ matx-continued-statement-offset
				   (current-column)
				   (if at-brace matx-continued-brace-offset 0))))
		      ;; Preceding line ended in comma or semi;
		      ;; use the standard indent for this level.
		      (if at-else
			  (progn (c-backward-to-start-of-if opoint)
				 (setq this-indent (current-indentation)))
			(setq this-indent (car indent-stack))))))
	      ;; Just started a new nesting level.
	      ;; Compute the standard indent for this level.
	      (let ((val (matx-calculate-indent
			  (if (car indent-stack)
			      (- (car indent-stack))))))
		(setcar indent-stack
			(setq this-indent val))))
	    ;; Adjust line indentation according to its contents
	    (if (looking-at "\\(public\\|private\\|protected\\):")
		(setq this-indent (- this-indent matx-indent-level)))
	    (if (or (looking-at "case[ \t]")
		    (and (looking-at "[A-Za-z]")
			 (save-excursion
			   (forward-sexp 1)
			   (looking-at ":[^:]"))))
		(setq this-indent (max 0 (+ this-indent matx-label-offset))))
	    (if (looking-at "friend[ \t]class[ \t]")
		(setq this-indent (+ this-indent matx-friend-offset)))
	    (if (= (following-char) ?})
		(setq this-indent (- this-indent matx-indent-level)))
	    (if (= (following-char) ?{)
		(setq this-indent (+ this-indent matx-brace-offset)))
	    ;; Put chosen indentation into effect.
	    (or (= (current-column) this-indent)
		(= (following-char) ?\#)
		(progn
		  (delete-region (point) (progn (beginning-of-line) (point)))
		  (indent-to this-indent)))
	    ;; Indent any comment following the text.
	    (or (looking-at comment-start-skip)
		(if (re-search-forward
		     comment-start-skip
		     (save-excursion (end-of-line) (point)) t)
		    (progn (indent-for-comment) (beginning-of-line))))))))))

(defun matx-fill-MaTX-comment ()
  "Fill a MaTX style comment."
  (interactive)
  (save-excursion
    (let ((save fill-prefix))
      (beginning-of-line 1)
      (save-excursion
	(re-search-forward comment-start-skip
			   (save-excursion (end-of-line) (point))
			   t)
	(goto-char (match-end 0))
	(set-fill-prefix))
      (while (looking-at fill-prefix)
	(forward-line -1))
      (forward-line 1)
      (insert-string "\n")
      (fill-paragraph nil)
      (delete-char -1)
      (setq fill-prefix save))))

(defun matx-point-bol ()
  "Returns the value of the point at the beginning of the current
line."
  (save-excursion
    (beginning-of-line)
    (point)))

(defun matx-insert-header ()
  "Insert header denoting MaTX code at top of buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (insert "// "
;	    "This may look like C/C++ code, but it is really "
	    "-*- MaTX -*-"
	    "\n\n")))


;;; this page contains functions which try to tame single quotes in
;;; comment regions

(defun matx-tame-comments ()
  "Backslashifies all single quotes in comment regions found in the buffer.
This is the best available workaround for an emacs syntax bug in
scan-lists which exists at least as recently as v18.58"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (while (re-search-forward "[^\\][][{}()']" (point-max) 'move)
      (if (and matx-scan-lists-bug-exists
	       (matx-in-comment-p))
	  (progn (forward-char -1)
		 (insert "\\"))))))


;;; This page covers "macroization;" making MaTX parameterized types
;;; via macros.

(defvar matx-default-macroize-column 78
  "*Place to insert backslashes.")

(defun matx-macroize-region (from to arg)
  "Insert backslashes at end of every line in region.  Useful for defining cpp
macros.  If called with negative argument, will remove trailing backslashes,
so that indentation will work right."
  (interactive "r\np")
  (save-excursion
    (goto-char from)
    (beginning-of-line 1)
    (let ((line (count-lines (point-min) (point)))
	  (to-line (save-excursion (goto-char to)
				   (count-lines (point-min) (point)))))
      (while (< line to-line)
	(matx-backslashify-current-line (> arg 0))
	(forward-line 1) (setq line (1+ line))))))

(defun matx-backslashify-current-line (doit)
  "Backslashifies current line."
  (end-of-line 1)
  (cond
   (doit
    ;; Note that "\\\\" is needed to get one backslash.
    (if (not (save-excursion (forward-char -1) (looking-at "\\\\")))
	(progn
	  (if (>= (current-column) matx-default-macroize-column)
	      (insert " \\")
	    (while (<= (current-column) matx-default-macroize-column)
	      (insert "\t") (end-of-line))
	    (delete-char -1)
	    (while (< (current-column) matx-default-macroize-column)
	      (insert " ") (end-of-line))
	    (insert "\\")))))
   (t
    (forward-char -1)
    (if (looking-at "\\\\")
	(progn (skip-chars-backward " \t")
	       (kill-line))))))


;;; This page covers commenting out multiple lines.

(defun matx-comment-region ()
  "Comment out all lines in a region between mark and current point by
inserting \"// \" (comment-start)in front of each line."
  (interactive)
  (let* ((m      (if (eq (mark) nil) (error "Mark is not set!") (mark)))
	 (start  (if (< (point) m) (point) m))
	 (end    (if (> (point) m) (point) m))
	 (mymark (copy-marker end)))
    (save-excursion
      (goto-char start)
      (while (< (point) (marker-position mymark))
	(beginning-of-line)
	(insert comment-start)
	(beginning-of-line)
	(forward-line 1)))))

(defun matx-uncomment-region ()
  "Uncomment all lines in region between mark and current point by deleting
the leading \"// \" from each line, if any."
  (interactive)
  (let* ((m      (if (eq (mark) nil) (error "Mark is not set!") (mark)))
	 (start  (if (< (point) m) (point) m))
	 (end    (if (> (point) m) (point) m))
	 (mymark (copy-marker end))
	 (len    (length comment-start))
	 (char   (string-to-char comment-start)))
    (save-excursion
	(goto-char start)
	(while (< (point) (marker-position mymark))
	    (beginning-of-line)
	    (if (looking-at (concat " *" comment-start))
		(progn
		  (zap-to-char 1 char)
		  (delete-char (- len 1))))  ;;modified by the HiKer. <20 May 1995>
	    (beginning-of-line)
	    (forward-line 1)))))

;;; Below are two regular expressions that attempt to match defuns
;;; "strongly" and "weakly."  The strong one almost reconstructs the
;;; grammar of MaTX; the weak one just figures anything id or curly on
;;; the left begins a defun.  The constant "matx-match-header-strongly"
;;; determines which to use; the default is the weak one.

(defvar matx-match-header-strongly nil
  "*If NIL, use matx-defun-header-weak to identify beginning of definitions,
if nonNIL, use matx-defun-header-strong")

(defvar matx-defun-header-strong-struct-equivs ;"\\(class\\|struct\\|enum\\)"
  "\\(void\\|Integer\\|Real\\|Complex\\|String\\|Matrix\\|Array\\|Index\\|Polynomial\\|Rational\\|List\\|CoMatrix\\|PoMatrix\\|RaMatrix\\|CoArray\\|PoArray\\|RaArray\\|FILE\\)"
  "Regexp to match names of structure declaration blocks in MaTX")

(defconst matx-defun-header-strong
  (let*
      (; valid identifiers
       ;; There's a real wierdness here -- if I switch the below
       (id "\\(\\w\\|_\\)+")
       ;; to be
       ;; (id "\\(_\\|\\w\\)+")
       ;; things no longer work right.  Try it and see!

       ; overloadable operators
       (op-sym1
	 "[---+*/%^&|~!=<>]\\.?\\|[---+*/%^&|<>=!]\\.?=\\|<<=?\\|>>=?")
       (op-sym2
	 "&&\\|||\\|\\+\\+\\|--\\|()\\|\\[\\]\\|'")	 
       (op-sym (concat "\\(" op-sym1 "\\|" op-sym2 "\\)"))
       ; whitespace
       (middle "[^\\*]*\\(\\*+[^/\\*][^\\*]*\\)*")
       (matx-comment (concat "/\\*" middle "\\*+/"))
       (wh (concat "\\(\\s \\|\n\\|//.*$\\|" matx-comment "\\)"))
       (wh-opt (concat wh "*"))
       (wh-nec (concat wh "+"))
       (oper (concat "\\(" "operator" "\\("
		     wh-opt op-sym "\\|" wh-nec id "\\)" "\\)"))
       (dcl-list "([^():]*)")
       (func-name (concat "\\(" oper "\\|" id "::" id "\\|" id "\\)"))
       (inits
	 (concat "\\(:"
		 "\\(" wh-opt id "(.*\\()" wh-opt "," "\\)\\)*"
		 wh-opt id "(.*)" wh-opt "{"
		 "\\|" wh-opt "{\\)"))
       (type-name (concat
		    "\\(" matx-defun-header-strong-struct-equivs wh-nec "\\)?"
		    id))
       (type (concat "\\(const" wh-nec "\\)?"
		     "\\(" type-name "\\|" type-name wh-opt "\\*+" "\\|"
		     type-name wh-opt "&" "\\)"))
       (modifier "\\(inline\\|virtual\\|overload\\|auto\\|static\\|register\\|volatile\\|unsigned\\|extern\\)")
       (modifiers (concat "\\(" modifier wh-nec "\\)*"))
       (func-header
	 ;;     type               arg-dcl
	 (concat "Func" wh-nec modifiers type wh-nec func-name wh-opt dcl-list wh-opt inits))
       (inherit (concat "\\(:" wh-opt "\\(public\\|private\\)?"
			wh-nec id "\\)"))
       (cs-header (concat
		    matx-defun-header-strong-struct-equivs
		    wh-nec id wh-opt inherit "?" wh-opt "{")))
    (concat "^\\(" func-header "\\|" cs-header "\\)"))
  "Strongly-defined regexp to match beginning of structure or
function definition.")


;; This part has to do with recognizing defuns.

;; The weak convention we will use is that a defun begins any time
;; there is a left curly brace, or some identifier on the left margin,
;; followed by a left curly somewhere on the line.  (This will also
;; incorrectly match some continued strings, but this is after all
;; just a weak heuristic.)  Suggestions for improvement (short of the
;; strong scheme shown above) are welcomed.

(defconst matx-defun-header-weak ;"^{\\|^[_a-zA-Z].*{"
  "^Func"
  "Weakly-defined regexp to match beginning of structure or function definition.")


(defun matx-beginning-of-defun (arg)
  (interactive "p")
  (let ((matx-defun-header (if matx-match-header-strongly
			      matx-defun-header-strong
			    matx-defun-header-weak)))
    (cond ((or (= arg 0) (and (> arg 0) (bobp))) nil)
	  ((and (not (looking-at matx-defun-header))
		(let ((curr-pos (point))
		      (open-pos (if (search-forward "{" nil 'move)
				    (point)))
		      (beg-pos
			(if (re-search-backward matx-defun-header nil 'move)
			    (match-beginning 0))))
		  (if (and open-pos beg-pos
			   (< beg-pos curr-pos)
			   (> open-pos curr-pos))
		      (progn
			(goto-char beg-pos)
			(if (= arg 1) t nil));; Are we done?
		    (goto-char curr-pos)
		    nil))))
	  (t
	    (if (and (looking-at matx-defun-header) (not (bobp)))
		(forward-char (if (< arg 0) 1 -1)))
	    (and (re-search-backward matx-defun-header nil 'move (or arg 1))
		 (goto-char (match-beginning 0)))))))


(defun matx-end-of-defun (arg)
  (interactive "p")
  (let ((matx-defun-header (if matx-match-header-strongly
			      matx-defun-header-strong
			    matx-defun-header-weak)))
    (if (and (eobp) (> arg 0))
	nil
      (if (and (> arg 0) (looking-at matx-defun-header)) (forward-char 1))
      (let ((pos (point)))
	(matx-beginning-of-defun 
	  (if (< arg 0)
	      (- (- arg (if (eobp) 0 1)))
	    arg))
	(if (and (< arg 0) (bobp))
	    t
	  (if (re-search-forward matx-defun-header nil 'move)
	      (progn (forward-char -1)
		     (forward-sexp)
		     (beginning-of-line 2)))
	  (if (and (= pos (point)) 
		   (re-search-forward matx-defun-header nil 'move))
	      (matx-end-of-defun 1))))
      t)))

(defun matx-indent-defun ()
  "Indents the current function def, struct or class decl."
  (interactive)
  (let ((restore (point)))
    (matx-end-of-defun 1)
    (beginning-of-line 1)
    (let ((end (make-marker)))
      (set-marker end (point))
      (matx-beginning-of-defun 1)
      (while (and (< (point) end))
	(matx-indent-line)
	(forward-line 1)
	(beginning-of-line 1))
      (set-marker end nil))
    (goto-char restore)))


;; This page defines some configuration and functions of "MaTX-program.el"
;; written by unknown (maybe, Koga-san ;).
;; Such a .el program has long (since 1995, at least) been there at our site,
;; however it was derived from some older version of "gnu-plot.el" (1991)
;; written by Gershon Elber (see below).  So these codes here is re-hacked
;; from the newer version (1992).                         --HiK <1998/07/31>

;;; (A part of) original header of gnuplot.el  B-)
;
;; Id: gnuplot.el,v 1.4 1993/09/27 17:08:18 alex Exp 
; 
; gnu-plot.el - Definitions of GNU-PLOT mode for emacs editor.
; 
; Author:	Gershon Elber
; 		Computer Science Dept.
; 		University of Utah
; Date:	Tue May 14 1991
; Copyright (c) 1991, 1992, Gershon Elber
;
;;; detailed documentation snipped. BB-)

(defvar matx-program "matx"
  "*The executable to run for MaTX-program buffer.")

(defvar matx-echo-program nil
  "*Control echo of executed commands to MaTX-program buffer.")

; key definitions are gone to the earlier part of this program.
;  gnu-plot     matx-mode
;    M-e    -->  C-c C-e     to send-line-to-matx
;    M-r    -->  C-c C-r     to send-region-to-matx

;;;
;;; Define send-line-to-matx - send from current cursor position to next
;;; semicolin detected.
;;;
(defun send-line-to-matx ()
  "Sends one line of code from current buffer to the MaTX program.

Use to execute a line in the MaTX program.  The line sent is the line the
cursor (point) is on.

The MaTX program buffer name is MaTX-program and the process name is 'matx'.
If none exists, a new one is created.

The name of the MaTX program to execute is stored in matx-program variable
and may be changed."
  (interactive)
  (if (equal major-mode 'matx-mode)
    (progn
      (make-MaTX-buffer)        ; In case we should start a new one.
      (beginning-of-line)
      (let ((start-mark (point-marker)))
	(next-line 1)
	(let* ((crnt-buffer (buffer-name))
	       (end-mark (point-marker))
	       (string-copy (buffer-substring start-mark end-mark)))
	  (switch-to-buffer-other-window (get-buffer "MaTX-program"))
	  (end-of-buffer)
	  (if matx-echo-program
	    (insert string-copy))
	  (set-marker (process-mark (get-process "MaTX")) (point-marker))
	  (if (not (pos-visible-in-window-p))
	    (recenter 3))
	  (switch-to-buffer-other-window (get-buffer crnt-buffer))
	  (process-send-region "MaTX" start-mark end-mark)
	  (goto-char end-mark))))
    (message "Should be invoked in matx-mode only.")))

;;;
;;; Define send-region-to-matx - send from current cursor position to
;;; current marker.
;;;
(defun send-region-to-matx ()
  "Sends a region of code from current buffer to the MaTX program.

When this function is invoked on an MaTX file it send the region
from current point to current mark to the MaTX program.

The MaTX program buffer name is MaTX-program and the
process name is 'matx'.  If none exists, a new one is created.

The name of the MaTX program to execute is stored in matx-program variable
and may be changed."
  (interactive)
  (if (equal major-mode 'matx-mode)
    (progn
      (make-MaTX-buffer)     ; In case we should start a new one.
      (copy-region-as-kill (mark-marker) (point-marker))
      (let ((crnt-buffer (buffer-name)))
	(switch-to-buffer-other-window (get-buffer "MaTX-program"))
	(end-of-buffer)
	(if matx-echo-program
	  (yank))
	(set-marker (process-mark (get-process "MaTX")) (point-marker))
	(if (not (pos-visible-in-window-p))
	  (recenter 3))
	(switch-to-buffer-other-window (get-buffer crnt-buffer))
	(process-send-region "MaTX" (mark-marker) (point-marker))))
    (message "Should be invoked in matx-mode only.")))

;;;
;;; Switch to "matx-program" buffer if exists. If not, creates one and
;;; execute the program defined by matx-program.
;;;
(defun make-MaTX-buffer ()
  "Switch to matx-program buffer or create one if none exists"
  (interactive)
  (if (get-buffer "MaTX-program")
    (if (not (get-process "MaTX"))
      (progn
	(message "Starting MaTX interpreter program...")
	(start-process "MaTX" "MaTX-program" matx-program)
	(process-send-string "MaTX" "\n")
	(message "Done.")))
    (progn
      (message "Starting MaTX interpreter program...")
      (start-process "MaTX" "MaTX-program" matx-program)
      (process-send-string "MaTX" "\n")
      (message "Done."))))

;; To exit matx explicitly in case failing to kill the process...
;; It sometimes occurs on SunOS4.1.4J(dazai). X-(
(defun send-exit-to-matx ()
  "Sends 'exit' to MaTX program if MaTX process exists."
  (interactive)
  (if (and (get-buffer "MaTX-program")
	   (get-process "MaTX"))
      (progn
	(message "Sending 'exit' to MaTX process...")
	(process-send-string "MaTX" "\nexit\n")
	(message "Done."))
    (message "No MaTX buffer or process.")))


;; this page is provided for bug reports. it dumps the entire known
;; state of matx-mode so that I know exactly how you've got it set up.

(defconst matx-version "$Revision: 1.25 $"
  "matx-mode version number.")

(defun matx-version ()
  "Echo the current version of MaTX Mode in the minibuffer."
  (interactive)
  (message "Using MaTX Mode version %s." matx-version)
  (c-keep-region-active))

(defun matx-dump-state ()
  "Inserts into the matx-mode-state-buffer the current state of
matx-mode into the bug report mail buffer.

Use \\[matx-submit-bug-report] to submit a bug report."
  (let ((buffer (current-buffer))
	(varlist (list 'matx-continued-member-init-offset
		       'matx-member-init-indent
		       'matx-friend-offset
		       'matx-empty-arglist-indent
		       'matx-comment-only-line-offset
		       'matx-cleanup-}-else-{-p
		       'matx-hanging-braces
		       'matx-hanging-member-init-colon
		       'matx-mode-line-format
		       'matx-auto-hungry-initial-state
		       'matx-auto-hungry-toggle
		       'matx-hungry-delete-key
		       'matx-auto-newline
		       'matx-default-macroize-column
		       'matx-match-header-strongly
		       'matx-defun-header-strong-struct-equivs
		       'matx-tab-always-indent
		       'matx-indent-level
		       'matx-continued-statement-offset
		       'matx-continued-brace-offset
		       'matx-brace-offset
		       'matx-brace-imaginary-offset
		       'matx-argdecl-indent
		       'matx-label-offset
		       'tab-width
		       'matx-scan-lists-bug-exists
		       'matx-program
		       'matx-echo-program
		       )))
    (set-buffer buffer)
    (insert (emacs-version) "\n")
    (insert "matx-mode.el " matx-version
	    "\n\ncurrent state:\n==============\n(setq\n")
    (mapcar
     (function
      (lambda (varsym)
	(let ((val (eval varsym))
	      (sym (symbol-name varsym)))
	  (insert "     " sym " "
		  (if (or (listp val) (symbolp val)) "'" "")
		  (prin1-to-string val)
		  "\n"))))
     varlist)
    (insert "     )\n")))

(defun matx-submit-bug-report ()
  "Submit via mail a bug report using the mailer in matx-mailer."
  (interactive)
  (funcall matx-mailer)
  (insert matx-mode-help-address)
  (if (re-search-forward "^[Ss]ubject:[ \t]+" (point-max) 'move)
      (insert "Bug in matx-mode.el " matx-version))
  (if (not (re-search-forward mail-header-separator (point-max) 'move))
      (progn (goto-char (point-max))
	     (insert "\n" mail-header-separator "\n")
	     (goto-char (point-max)))
    (forward-line 1))
  (set-mark (point))			;user should see mark change
  (insert "\n\n")
  (matx-dump-state)
  (exchange-point-and-mark))


(provide 'matx-mode)

;;; matx-mode ends here.
