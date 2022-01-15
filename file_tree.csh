#File Tree structure

setenv DV_TOOL_VERSION    1.0.0
setenv DV_TOOL_ROOT       ./dv_scripts
setenv BAR_CMD            bar
setenv RGR_CMD            rgr
setenv DV_BAR_ROOT        $DV_TOOL_ROOT/${BAR_CMD}
setenv DV_RGR_TOOT        $DV_TOOL_ROOT/${RGR_CMD}

./VERSION           # Version number file (like 1.0.0.0)
./doc               # documentations

./bin               # Soft links to scripts executables, or new scripts

./flows             # main flow scripts (.mk for each target)
./flows/help*       # help*.txt
./flows/helpers     # *mk
./flows/bar.mk      # top level MK for Build & Run   
# sub dir
  ./include/common.mk   # call gmsl, define common mk variables like SHELL/VERBOSITY/QUIET ...
  ./include/gmsl        # wrapper of __gmsl by using ifndef/define/endif to avoid of duplicated call
  ./include/__gmsl      # GNU Make Standard Lib, version := 1.1.5

  ./utility.mk          # define UTILITY_TARGETS
  ./query.mk            # define query_info function

  ./dut.mk
  dut_lib.mk
  hdl.mk
  
  hvl.mk
  hvl_link.mk
  hvl_link_indut.mk
  
  tb.mk
  th.mk
  tb_doc.mk
  tb_libs.mk
  tb_lint.mk
  
  abv.mk
  abv_libs.mk
  
  elab.mk
  elab_dut.mk
  
  sim.mk
  sim_top.mk
  
  aldec.mk
  app.mk
  common_libs.mk
  compatibility.mk
  
  coverage.mk
  covercheck.mk
  
  debug.mk
  design_dump_info.mk
  enum.mk
  fsim.mk
  
  hlverif.mk
  hlverif_legacy_vars_mapping.mk
  ice.mk
  jasper.mk
  prove.mk
  
  macro.mk
  misc.mk
  pwrest.mk
  sandbox_ide.mk
  synopsys.mk
  template.mk
  test.mk
  tools.mk
  unr.mk
  upf.mk
  vc_formal.mk
  vcs_unr.mk
  vip_stats.mk
  
  
  
  

                 
                 
./template
./wrappers  

./scripts           # Wrapper/top level scripts based on libs

./lib               # libs for scripts, or .so/.a libs
./lib/linux
./lib/solaris

./perl_lib          # standalone/shared/utils perl libs for lib/scripts
./python_lib        # standalone/shared/utils py libs for lib/scripts





