(import sys argparse
        [hycc [--version--]]
        [hycc.core.build [build]])

(defclass Formatter [argparse.RawTextHelpFormatter]
  (defn -format-args [self action default-metavar]
    (setv get-metavar (.-metavar-formatter self action default-metavar))
    (try
     (.format "<{0:s}>" (first (get-metavar 1)))
    (except [] ""))))

(defn hycc-main [&optional [argv (cdr sys.argv)]]
  (setv parser (argparse.ArgumentParser
                :usage "%(prog)s [options] module..."
                :add_help False
                :formatter-class Formatter))

  (setv parser._optionals.title "options")

  (.add_argument parser
                 "module"
                 :nargs "+"
                 :help argparse.SUPPRESS)
  (.add_argument parser
                 "-o"
                 :nargs "*"
                 :metavar "file"
                 :help "place the output into <file>")
  (.add_argument parser
                 "--with-c"
                 :action "store_true"
                 :help "generate c code")
  (.add_argument parser
                 "--with-python"
                 :action "store_true"
                 :help "generate python code")
  (.add_argument parser
                 "--shared"
                 :action "store_true"
                 :help "create shared library")
  (.add_argument parser
                 "--version"
                 :action "version"
                 :version (+ "%(prog)s " --version--))
  (.add_argument parser
                 "--help"
                 :action "help"
                 :help "show this help and exit")

  (setv options (.parse-args parser argv))
  (if (= (len options.module) 0)
          (do (parser.print_usage) (exit)))
  (for [module options.module]
    (build module (if options.o (.pop options.o 0))
           options.shared options.with-c options.with-python)))
