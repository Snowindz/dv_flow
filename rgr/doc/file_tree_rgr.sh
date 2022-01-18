
./doc/
  ./helppages/ (*.pod)

./etc/    # fail/pass pattern (*.re)
  cad.re # tool related pass/fail ptn
    # FAIL PATTERN
    #   - Simulation FAILED
    #   - PROVE FAILED
    # PASS PATTERN
    #   - Simulation PASSED
    #   - PROVE SUCCESS
    # COMPLETE Pattern
    #   - $finish
    #   - Simulation complete
    #   - ^$finish\s+at\s+simulation\s+time
    #   - PROVE_DONE
    # ASSSERTION PATTERN
    #   - /\s*Offending\s\+
    #   - /Assertion violation/
    #   - /Assertion error/
    #   - /started at (.*) failed at (.*)
    # Designware pattern
    #   - DesignWare Model FATAL
    #   - DesignWare Model ERROR from 
    #   - DesignWare Model WARNING
    # DENALI ptn
    #   - Denali (.*) Warning:
    #   - Denali\*\s+Error:
    # UVM PATTERN
    #   - UVM_ERROR/FATAL/WARNING
    # VIP Ptn
    #   - VERIFICATION ERROR
    # IGNORE PTN
    #   -
    
    
  it.re
    # License checkout failure
    # Error: Failure to license for 
    # Can\'t check\s+out\s+license
    # Can\'t connect License Server


./lib/
  ./linux/      # libdb-4.3.so/la/a
  ./sun/
  
./perlib/       # custum perllib packages (*.pm) for scripts
./scripts/
  rgr           # step: tb/th/dut/sim_top/abv/sim/prove/elab
  get_rgr_test_status
    # parse_re_files
  ./internal/bmd*
  
./utils/
./FlowTracer/

