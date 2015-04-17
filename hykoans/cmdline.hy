(import sys unittest os glob)
(import [hykoans [koans [a_asserts b_language]]])

(defn file-to-module [x]
  (setv file-without-filename (x.replace ".hy" ""))
  (file-without-filename.replace "/" "."))

; DEBUG - for passing in the `letter name` of the koan module
(setv module-letter-name (nth sys.argv 1 ""))

(setv modules
  (filter
    (fn [x]
      (not (in "__init__" x)))
    (map file-to-module (glob.glob (.format "koans/{}*.hy" module-letter-name)))))

(setv module-args (list-comp (get sys.modules module) [module modules]))

(setv loader (unittest.TestLoader))
(setv suite (loader.loadTestsFromModule (first module-args)))

(for [module (rest module-args)]
     (suite.addTests (loader.loadTestsFromModule module)))

(setv runner (apply unittest.TextTestRunner [] {"verbosity" 2 "failfast" true}))

(defn main []
  (runner.run suite))