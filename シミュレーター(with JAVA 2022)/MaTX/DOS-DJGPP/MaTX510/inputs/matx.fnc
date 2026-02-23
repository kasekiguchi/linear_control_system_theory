< Builtin Function >>

** First Step **

  demo: Demonstration
  help: Help message
  quit: Exit from MaTX

** Managing variables and functions

  clear: Clear variables
  gets:  Read one line from standard input
  kbhit: Check if there exists a data in standard input
  load:  Read MM-files
  print: Display variables
  print: Display formatted data to standard output
  read:  Input variables from standard input
  save:  Save varialbes as a MM-file
  scanf: Input formatted data from standard input
  what:  List registered functions
  which: Display information of functions
  who:   List registered variables
  whos:  Display information of variables

** Working with files and operating system

  chdir:   Change the working directory
  getenv:  Get environment variable
  mkdir:   Make a directory
  pclose:  Close a pipe
  popen:   Open a pipe
  remove:  Remove a file
  rename:  Rename a file
  rmdir:   Remove a directory
  setenv:  Set environment variable
  system:  Execute operating system command
   !       Execute operating system command

** Controlling the screen **

  clear:   Clear the screen
  gotoxy:  Move the cursor on the screen

** Special variables **

  ans:   Most recent answer
  NaN:   Not-a-Number
  EPS:   Floating point relative accuracy
  nargs: Number orf function input arguments
  Inf:   Infinity
  PI:    3.1415926535897

** Operators and Special Characters

    +: Plus              
   .+: Array Plus        
   ++: Increment with 1  
    -: Minus             
   .-: Array Minus       
   --: Decrement with 1  
    *: Multiplication 
   .*: Multiplication (element-wise)   
    /: Right division
   ./: Right division (element-wise)
    \: Left division
   .\: Left division (element-wise)
    ^: Power
   .^: Array Power
    ~: Inverse
   .~: Inverse (element-wise)
    #: Complex conjugate transpose
    ': Transpose
    =: Assignemnt
   ==: Equality
  .==: Equality (element-wise)
   !=: Nonequality
  .!=: Nonequality (element-wise)
    >: Greater
   .>: Greater (element-wise)
   >=: Greater or equal
  .>=: Greater or equal (element-wise)
    <: Less
   .<: Less (element-wise)
   <=: Less or equal
  .<=: Less or equal (element-wise)
   &&: Logical AND
  .&&: Logical AND (element-wise)
   ||: Logical OR
  .||: Logical OR (element-wise)
    !: Logical NOT
   .!: Logical NOT (element-wise)
    :: Colon, case
   (): Parentheses
   []: Vector, Matrix
   {}: Function, List
   "": String
  (,): Complex Value
   >>: Save matrix to MAT-format file
   <<: Load matrix from MAT-format file
   ->: Save data to MX-format file
   <-: Load data from MX-format file
    .: Decimal point
  ...: Function with varying number of arguments
    ,: Comma
    ;: End of statement
   //: One line comment
   /*: Beginning of block comment
   */: End of block comment
    !: Execute operating system command

** Logical functions **

  all:       1 if all elements of matrix are not zero
  all_col:   1 if all elements of each column are not zero
  all_row:   1 if all elements of each row are not zero
  any:       1 if any element of matrix is not zero
  any_col:   1 if any element of each column is not zero
  any_row:   1 if any element of each row is not zero
  exist:     Check if variable exist
  find:      Find indices of non-zero elements
  iscomplex: 1 for complex value
  isempty:   1 for empty matrix
  isfinite:  1 for finite element
  isinf:     1 for infinite element
  isnan:     1 for Not-A-Number
  isreal:    1 for real value

** Declaration and definition of variables and functions **

  extern:  Declaration of variables in other files
  Func:    Definition of function
  nargs:   Number of the arguments of the function
  require: Relation of function and mm-file
  static:  Declaration of static variable

** Control flow **

  break:    Terminate execution of loop
  case:     Case of selection
  continue: Restart the loop
  default:  Default case
  do:       Loop
  else:     Conditionaly execute statements
  else if:  Conditionaly execute statements
  error:    Display error messages and abort execution
  exit:     Terminate execution
  for:      Repeat statements util the condition is true
  if:       Conditionaly execute statements
  return:   Return to invoking function
  switch:   Selection
  while:    Repeat statements until the condition is true

** Interactive input **

  bell:     Ring the bell
  kbhit:    Check if there exists a data in standard input
  menu:     Generate menu of choices
  pause:    Wait for user response
  warning:  Display warning message

** Time and date **

  clock:    Current date and time
  settimer: Reset the interval timer
  gettimer: Get the time of interval timer

** Elementary function **

  abs:     Absolute value         
  acos:    Inverse cosine         
  acosh:   Inverse hyperbolic cosine
  arg:     Phase angle
  asin:    Inverse sine
  asinh:   Inverse hyperbolic sine
  atan:    Inverse tangent
  atan2:   Four quadrant inverse tangent
  atanh:   Inverse hyperbolic tangent
  ceil:    Round towards plus infinity
  conj:    Complex conjugate
  cos:     Cosine
  cosh:    Hyerbolic cosine
  exp:     Exponential
  fact:    Factorial
  fix:     Round towards zero
  floor:   Round towards minus infinity
  Im:      Complex imaginary part
  inv:     Inverse
  log:     Natural logarithm
  log10:   Common logarithm
  pow:     Power
  Re:      Complex real part
  rem:     Remainder after division
  round:   Round towards nearest integer
  round2z: Round towards zero
  sgn:     Signum function
  sin:     Sine
  sinh:    Hyperbolic sine
  sqrt:    Square root
  tan:     Tangent
  tanh:    Hyperbolic tangent

** Bit operation **

  bit_and:        bit-wise AND 
  bit_or:         bit-wise OR
  bit_xor:        bit-wise exclusive OR
  bit_comp:       bit-wise reverse(complement of 1)
  bit_lshift:     bit-wise left-shift
  bit_rshift:     bit-wise right-shift
  machine_endian: Endian of binary data

** Elementary matrix **

  I:        Identify matrix
  linspace: Linearly spaced vector
  logpsace: Logarithmically spaced vector
  ONE:      Onese matrix
  rand:     Uniformly distributed random numbers
  randn:    Normally distributed random numbers
  Z:        Zeros matrix

** Attribute of matrix **

  size:    Number of rows and number of columns
  Cols:    Number of columns
  Rows:    Number of rows
  length:  Maximum of number of rows and number of columns
  isempty: Check if empty matrix

** Matrix manipulation **

  Array:       Translation to array
  conj:        Complex conjugate
  conjtrans:   Complex conjugate transpose
  De:          Denominator array
  diag:        Diagonal matrix
  diag2vec:    Create vector from diagonal elements
  vec2diag:    Create diagonal matrix from a vector
  fliplr:      Flip matrix in the left/right direction
  flipud:      Flip matrix in the up/down direction
  Im:          Imaginary part of complex matrix
  Index:       Translation to index
  Matrix:      Translation to matrix
  Nu:          Numerator array
  Re:          Real part of complex matrix
  reshape:     Change size
  rot90:       Rorate matrix 90 degrees
  rotateDown:  Rotate matrix in the down direction
  rotateLeft:  Rotate matrix in the left direction
  rotateRight: Rotate matrix in the right direction
  rotateUp:    Rotate matrix in the up direction
  diag_vec:    Exchange diagonal matrix and vector
  shiftDown:   Shift matrix elements in the down direction
  shiftLeft:   Shift matrix elements in the left direction
  shiftRight:  Shift matrix elements in the right direction
  shiftUp:     Shift matrix elements in the up direction
  trans:       Transpose
  tril:        Extract lower triangular part
  triu:        Extract upper triangular part
    
** Matrix analysis **

  cond:     Matrix condition number
  det:      Determinant
  frobnorm: Frobenius norm of matrix
  norm:     Matrix or vector norm of matrix
  infnorm:  Infinity norm of matrix
  kernel:   Span of kernel space
  rank:     Number of linearly independent rows or columns
  trace:    Sum of diagonal elements

** Linear equations **

  / and \:        Linear equation solution
  chol:           Cholesky factorization
  inv:            Matrix inverse
  lu:             LU factorization
  lu_p:           LU factorization with permutation
  pseudoinv:      Pseudoinverse
  qr:             QR factorization
  qr_p:           QR factorization with permutation

** Eigenvalues and singular values **

  balance:      Diagonal scaling to improve eigenvalue accuracy
  eig:          Eigenvalues and eigenvectors
  eigval:       Eigenvalues
  eigvec:       Eiegenvectors
  hess:         Hessenberg form
  maxsing:      Maximum singular value
  minsing:      Minimum singular value
  poly:         Characteristic polynomial
  qz:           QZ factorization
  singleftvec:  Left transformation matrix for SVD
  singrightvec: Right transformation matrix for SVD
  singval:      Singular values
  schur:        Schur decomposition
  svd:          Singular value decomposition

** Matrix functions **

  exp:  Matrix exponential
  log:  Matrix logarithm
  sqrt: Matrix square root
  funm: Evaluate general matrix function

** Data analysis **

  cumprod:      Cumulative products of all elements
  cumprod_col:  Cumulative products of each column
  cumprod_row:  Cumulative products of each row
  cumsum:       Cumulative sum of all elements
  cumsum_col:   Cumulative sum of each column
  cumsum_row:   Cumulative sum of each row
  frobnorm:     Frobenius norm of all elements
  frobnorm_col: Frobenius norm of each column
  frobnorm_row: Frobenius norm of each row
  max:          Largest component among all elements
  max_col:      Largest component among each column
  max_row:      Largest component among each row
  maximum:      Largest component and the index among all elements
  maximum_col:  Largest component and the index among each column
  maximum_row:  Largest component and the index among each row
  mean:         Average or mean value of all elements
  mean_col:     Average or mean value of each column
  mean_row:     Average or mean value of each row
  median:       Median value of all elements
  median_col:   Median value of each column
  median_row:   Median value of each row
  min:          Smallest component of all elements
  min_col:      Smallest component of each column
  min_row:      Smallest component of row column
  minimum:      Smallest component and the index of all elements
  minimum_col:  Smallest component and the index of each column
  minimum_row:  Smallest component and the index of each row
  prod:         Product of all elements
  prod_col:     Product of each column
  prod_row:     Product of each row
  sort:         Sort in ascending order of all elements
  sort_col:     Sort in ascending order of each column
  sort_row:     Sort in ascending order of each row
  std:          Standard deviation of all elements
  std_col:      Standard deviation of each column
  std_row:      Standard deviation of each row
  sum:          Sum of all elements
  sum_col:      Sum of each column
  sum_row:      Sum of each row
                   
** Difference and correlation **

  diff:          Difference of all elements
  diff_col:      Difference of each column
  diff_row:      Difference of each row
  corrcoef:      Correlation coefficients of all elements
  corrcoef_col:  Correlation coefficients of each column
  corrcoef_row:  Correlation coefficients of each row
  cov:           Covariance matrix of all elements
  cov_col:       Covariance matrix of each column
  cov_row:       Covariance matrix of each row
  hist:          Histgram of all elements
  hist_col:      Histgram of each column
  hist_row:      Histgram of each row

** Simulation **

  rngkut4:         Solve ODE by Runge-Kutta method
  rkf45:           Solve ODE by RKF45 method
  Ode:             Solve ODE by RK with constant step size
  OdeAuto:         Solve ODE by RK with specified accuracy
  OdeHybrid:       Solve ODE by RK with constant step size, where the
                   External signal is constant for sampling interval
  OdeHybridAuto:   Solve ODE by RK with specified accuracy, where the
                   External signal is constant for the sampling interval
  Ode45:           Solve ODE by RKF45 with constant step size
  Ode45Auto:       Solve ODE by RKF45 with specified accuracy
  Ode45Hybrid:     Solve ODE by RKF45 with constant step size, where the
                   External signal is constant for sampling interval
  Ode45HybridAuto: Solve ODE by RKF45 with specified accuracy, where the
                   External signal is constant for sampling interval
  OdeStop:         Stop simulation
  OdeXY:           Get past signal

** Fourier Transforms **

  abs:         Magnitude
  arg:         Phase angle
  fft:         Discrete Fourier transfrom of all elements
  fft_col:     Discrete Fourier transfrom of each column
  fft_row:     Discrete Fourier transfrom of each row
  ifft:        Inverse discrete Fourier transform of all elements
  ifft_col:    Inverse discrete Fourier transform of each column
  ifft_row:    Inverse discrete Fourier transform of each row
  unwrap:      Remove phase angle jumps across 360 degrees boundaries
  unwrap_col:  Remove phase angle jumps of each column
  unwrap_row:  Remove phase angle jumps of each row

** Polynomial and rational polynomial **

  CoPolynomial: Translation to complex polynomial
  CoRational:   Translation to complex rational polynomial
  De:           Denominator polynomial
  derivativ:    Derivative
  degree:       Degree of polynomial
  higher:       Shift coefficients toward high order
  Im:           Imaginary part
  integral:     Indefinite integral
  lower:        Shift coefficients toward the lower order
  eval:         Evaluation of polynomial and rational polynomial
  Matrix:       Create vector from coefficients of polynomial
  Nu:           Numerator polynomial
  poles:        Poles (roots of denominator polynomial)
  Polynomial:   Translation to polynomial
  poly:         Characteristic polynomial
  Rational:     Translation to rational polynomial
  Re:           Real part
  roots:        Roots of polynomial
  simplify:     Cancelation of common factor of rational polynomial
  zeros:        Zeros(roots of numerator polynomial)

** String **

  eval:    Interpret strings containing MaTX expressions
  length:  Length of string
  Matrix:  Create vector from a string
  sprintf: Make formatted data to a string
  sscanf:  Read string under format control
  strchr:  Location of a character in the string (from head)
  strrchr: Location of a character in the string (from tail)
  String:  Translation to string

** List **

  length:   Number of elements
  List:     Translation to list
  makelist: Make a list
  typeof:   Type of elements of list

** File input/output functions **

  access:  Determine accessibility of file
  fclose:  Close file
  feof:    Check end of file
  fgets:   Get a string from file
  fread:   Read binary data from file as specified precision
  fopen:   Open file
  fprintf: Convert, format and write data to file
  fscanf:  Read data from a file with format
  fwrite:  Write binary data to file as specified precision
  load:    Read MM-file
  print:   Save variable as MX-format or MAT-format
  read:    Read variables MX-format or MAT-format data from file
  save:    Save variables as MM-file

** Interface to hardware **

  Inport:   Read 1 word data from IO port
  Inportb:  Read 1 byte data from IO port
  Outport:  Write 1 word data to IO port
  Outportb: Write 1 byte data to IO port

<< Matrix Toolbox >>

 mat_demo:        Demonstration of matrix toolbox

 angle:           Phase angles in radians
 bar:             Data for bar graph
 barp:            Plot Bar graph
 cdf2rdf:         Complex diagonal form to real diagonal form
 ccpair:          Make complex conjugate pairs
 dec2hex:         Decimal to hexadecimal number conversion
 deconv:          Deconvolution
 dft:             Discrete Fourier transform
 dft_plot:        Plot the data of discrete fourier transform 
 givens:          Givens rotation matrix
 hadamard:        Hadamard matrix
 hankel:          Hankel matrix
 hex2dec:         Hexadecimal to decimal number conversion
 hex2num:         IEEE hexidecimal to double precision number conversion
 hilbert:         Hilbert matrix
 idft:            Inverse Discrete Fourier Transform
 idft_plot:       Plot the data of inverse discrete fourier transform
 ihilbert:        Inverse Hilbert matrix
 kronprod:        Kronecker product
 kronsum:         Kronecker sum
 magicsq:         Magic square
 makecolv:        Make a column vector
 makerowv:        Make a row vector
 makepoly:        Characteristic polynomial
 mat2tex:         Save a matrix to a file in tex-form
 mat2texf:        Generate the tex-form of a matrix
 matlab_read:     Load matrices from a file saved as matlab4 mat-format
 matlab_write:    Save matrices from a file saved as matlab4 mat-format
 mseq:            M sequence
 nargchk:         Check number of input arguments
 null:            Null space basis
 orth:            Orthogonal basis
 rsf2csf:         Real Schur form to complex Schur form conversion
 schord:          Ordered schur decomposition
 simplify:        Cancellation of rational polynomials
 toeplitz:        Toeplitz matrix
 vander:          Vandermonde matrix
 vconnect:        Connect some vectors to a vector
 vchop:           Chop a vector to some vectors

<< Signal Toolbox >>

 sig_demo:        Demonstration of signal toolbox

 bartlett:        Bartlett window
 bilinear:        Bilinear transformation
 blackman:        Blackman window
 boxcar:          Rectangular window
 cceps:           Complex cepstrum
 detrend:         Same as detrend_row()
 detrend_col:     Remove a linear trend for each column
 detrend_row:     Remove a linear trend for each row
 filter:          Digital filter
 freqs:           Analog filter frequency response
 freqz:           Digital filter frequency response
 freqzw:          Digital filter frequency response
 hamming:         Hamming window
 hanning:         Hanning window
 rceps:           Real cepstrum
 sawtooth:        Sawtooth wave
 square:          Square wave
 triang:          N-point triangular window
 xcorr:           Cross-correlation function
 xcov:            Cross-covariance function

<< Control Toolbox >>

 ctr_demo:        Demonstration program for control toolbox

 abcdchk:         Check the dimensions of A,B,C,D
 are:             Solution of continuous-time Riccati equation
 augment:         Augmented system 
 balreal:         Balanced state-space realization
 bode_ss:         Bode response of continuous-time linear systems
 bode_tf:         Bode response of continuous-time linear systems
 bode_tfn:        Bode response of continuous-time linear systems
 bode_tfm:        Bode response of continuous-time linear systems
 bode_plot_ss:    Bode response of continuous-time linear system
 bode_plot_tf:    Bode response of continuous-time linear system
 bode_plot_tfn:   Bode response of continuous-time linear system
 bode_plot_tfm:   Bode response of continuous-time linear system
 charpoly:        Characteristic polynomial
 ctrm:            Controllability matrix
 ctrf:            Controllable-uncontrollable decomposition
 c2d:             Continuous-time to discrete time conversion
 canon:           State-space to canonical form transformation
 dbode_ss:        Discrete-time Bode response 
 dbode_plot_ss:   Plot discrete-time Bode response 
 dhinf:           Solve H_infinity Problem (Discrete-time case)
 dimpulse:        Impulse response of discrete-time linear systems
 dlqe:            Discrete linear quadratic estimator design
 dlqr:            Linear quadratic regulator design for discrete-time systems
 dlsim:           Simulation of discrete-time linear systems
 dlyap:           Discrete-time Lyapunov equation solution
 dric:            Discrete-time Riccati equation
 dstep:           Step response of discrete-time linear systems
 d2c:             Conversion from discrete to continuous time
 dbalreal:        Discrete balanced realization and model reduction
 dgramian:        Discrete-time controllability and observability gramians
 faddeev:         Resolvent matrix by Faddeev's method
 feedback:        Connect two state-space systems using feedback
 feedbk:          State-space closed-loop transfer function
 mseqfr:          Frequency response of a system by M sequence
 gmargin:         Gain margin and crossover frequencies
 gramian:         Controllability and observability gramians
 hinf:            Solve H_infinity problem (Continuous-time case)
 impulse:         Impulse response of continuous-time linear systems
 lqe:             Linear quadratic estimator design for the cont- system
 lqr:             Linear quadratic regulator design for cont- systems
 lqrs:            Linear-quadratic regulator design for cont- systems
 lqry:            Linear quadratic regulator design with output weighting
 ltifr:           Frequency response of linear time-invarient system
 ltitr:           Linear time-invariant time response
 lyap:            Solution of Lyapunov equation
 margin:          Gain margin, phase margin, and crossover frequencies
 minreal:         Minimal realization and pole-zero cancellation
 nicholsp:        Nichols chart
 nyquist_ss:      Nyquist response of cont- linear state-space systems
 nyquist_tf:      Nyquist response of cont- linear state-space systems
 nyquist_tfn:     Nyquist response of cont- linear state-space systems
 nyquist_tfm:     Nyquist response of cont- linear state-space systems
 nyquist_plot_ss: Plot Nyquist response of continuous-time systems
 nyquist_plot_tf: Plot Nyquist response of continuous-time systems
 nyquist_plot_tfn:Plot Nyquist response of continuous-time systems
 nyquist_plot_tfm:Plot Nyquist response of continuous-time systems
 obsg:            Minimal order observer by Gopinath's method
 obsf:            Observable-unobservable decomposition
 obsm:            Observability matrix
 parallel:        Parallel connection of two state-space systems
 pplace:          Pole placement
 pmargin:         Phase margin and crossover frequencies
 resolvent:       Resolvent matrix (s*I - A)^(-1) of matrix A
 ric:             Riccati equation using Potter and Arimoto's method
 riccati:         Riccati equation (Continuous-time case)
 rlocus_ss:       Root locus
 rlocus_tf:       Root locus
 rlocus_tfn:      Root locus
 rlocus_tfm:      Root locus
 rlocus_plot_ss:  Root locus plot
 rlocus_plot_tf:  Root locus plot
 rlocus_plot_tfn: Root locus plot
 rlocus_plot_tfm: Root locus plot
 series:          Series connection of two state-space systems
 svfr:            Singular value frequency response
 ss2tf:           State-space to transfer function conversion
 ss2tfn:          State-space to transfer function conversion
 ss2tfm:          State-space to transfer function matrix conversion
 ss2zp:           State-space to zero-pole conversion
 step_ss:         Step response of continuous-time linear systems
 step_tf:         Step response of continuous-time linear systems
 step_tfn:        Step response of continuous-time linear systems
 step_tfm:        Step response of continuous-time linear systems
 TFadd:           Parallel connection of two state-space systems
 TFinv:           Inverse a state-space system
 TFmul:           Series connection of two state-space systems
 TFnegate:        Negate a state-space system
 TFsub:           Parallel connection of two state-space systems
 TFtrans:         Trans a state-space system
 tfm2ss:          Transfer function matrix to state-space conversion
 tfm2tf:          Transfer function matrix to transfer function conversion
 tfm2tfn:         Transfer function matrix to transfer function conversion
 tfm2zp:          Transfer function matrix to zero-pole conversion
 tf2ss:           Transfer function to state-space conversion
 tf2tfn:          Transfer function to transfer function conversion
 tf2tfm:          Transfer function to transfer function matrix conversion
 tf2zp:           Transfer function to zero-pole conversion
 tfn2ss:          Transfer function to state-space conversion
 tfn2tf:          Transfer function to transfer function conversion
 tfn2tfm:         Transfer function to transfer function matrix conversion
 tfn2zp:          Transfer function to zero-pole conversion
 tzero:           Transmission zeros
 zp2ss:           Zero-pole to state-space conversion
 zp2tf:           Zero-pole to transfer function conversion
 zp2tfn:          Zero-pole to transfer function conversion
 zp2tfm:          Zero-pole to transfer function matrix conversion

<< Graph Toolbox >>

 ( GNUPLOT for the current window) 
 gcls:              Clear the graphical screen for Tektro emulation
 gplot:             Linear x-y Plot with GNUPLOT
 gplot_clear:       Clear screen
 gplot_cmd:         Send any commands with "\n" to gnuplot
 gplot_figcode:     Save the graph as a FIG code
 gplot_grid:        Grid lines
 gplot_hold:        Hold command (DOS, Windows95/NT)
 gplot_key:         Key lines
 gplot_loglog:      Loglog x-y plot
 gplot_options:     Set gnuplot options
 gplot_out:         Send any commands to gnuplot
 gplot_psout:       Save the graph as a postscript file
 gplot_quit:        Quit mgplot
 gplot_replot:      Replot lines
 gplot_reset:       Initialize window
 gplot_semilogx:    Semi-log x-y plot (x-axis logarithmic)
 gplot_semilogy:    Semi-log x-y plot (y-axis logarithmic)
 gplot_text:        Put text on the screen
 gplot_title:       Graph title
 gplot_xlabel:      X-axis label
 gplot_ylabel:      Y-axis label
 greplot:           Linear x-y rePlot with GNUPLOT
 greplot_loglog:    Loglog x-y replot
 greplot_semilogx:  Semi-log x-y replot (x-axis logarithmic)
 greplot_semilogy:  Semi-log x-y replot (y-axis logarithmic)

 ( GNUPLOT for the specified window) 
 mgplot:            Linear x-y Multiple Plot
 mgplot_clear:      Clear screen
 mgplot_cmd:        Send any commands with "\n" to gnuplot
 mgplot_figcode:    Save the graph as a FIG code
 mgplot_grid:       Grid lines
 mgplot_hold:       Hold command (DOS, Windows95/NT)
 mgplot_key:        Key lines
 mgplot_loglog:     Loglog x-y plot
 mgplot_options:    Set gnuplot options
 mgplot_out:        Send any commands to gnuplot
 mgplot_psout:      Save the graph as a postscript file
 mgplot_quit:       Quit mgplot
 mgplot_replot:     Replot lines
 mgplot_reset:      Initialize window
 mgplot_semilogx:   Semi-log x-y plot (x-axis logarithmic)
 mgplot_semilogy:   Semi-log x-y plot (y-axis logarithmic)
 mgplot_text:       Put text on the screen
 mgplot_title:      Graph title
 mgplot_xlabel:     X-axis label
 mgplot_ylabel:     Y-axis label
 mgreplot:          Linear x-y Multiple rePlot
 mgreplot_loglog:   Loglog x-y replot
 mgreplot_semilogx: Semi-log x-y replot (x-axis logarithmic)
 mgreplot_semilogy: Semi-log x-y replot (y-axis logarithmic)
 
 mesh_gplot:        Mesh Plot by using gnuplot

 -- For help on any topic, type 'help' followed by the name of the topic --

