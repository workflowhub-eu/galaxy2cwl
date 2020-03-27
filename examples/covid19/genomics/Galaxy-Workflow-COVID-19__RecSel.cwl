class: Workflow
cwlVersion: v1.2.0-dev1
doc: 'Abstract CWL generated from Galaxy: COVID-19: RecSel'
inputs:
  S_nt.fna:
    format: data
    type: File
outputs: {}
steps:
  1_transeq:
    in:
      input1: S_nt.fna
    out:
    - out_file1
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu_repos_devteam_emboss_5_EMBOSS_transeq101_5.0.0
      inputs:
        input1:
          format: Any
          type: File
      outputs:
        out_file1:
          doc: fasta
          type: File
  2_MAFFT:
    in:
      inputSequences: 1_transeq/out_file1
    out:
    - outputAlignment
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu_repos_rnateam_mafft_rbc_mafft_7.221.3
      inputs:
        inputSequences:
          format: Any
          type: File
      outputs:
        outputAlignment:
          doc: fasta
          type: File
  3_tranalign:
    in:
      input1: S_nt.fna
      input2: 2_MAFFT/outputAlignment
    out:
    - out_file1
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu_repos_devteam_emboss_5_EMBOSS_tranalign100_5.0.0
      inputs:
        input1:
          format: Any
          type: File
        input2:
          format: Any
          type: File
      outputs:
        out_file1:
          doc: fasta
          type: File
  4_FASTTREE:
    in:
      input_selector|input: 3_tranalign/out_file1
    out:
    - output
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu_repos_iuc_fasttree_fasttree_2.1.10+galaxy1
      inputs:
        input_selector|input:
          format: Any
          type: File
      outputs:
        output:
          doc: nhx
          type: File
  5_HyPhy-GARD:
    in:
      input_file: 3_tranalign/out_file1
    out:
    - gard_log
    - gard_output
    - translated
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu_repos_iuc_hyphy_gard_hyphy_gard_2.5.4+galaxy0
      inputs:
        input_file:
          format: Any
          type: File
      outputs:
        gard_log:
          doc: txt
          type: File
        gard_output:
          doc: nex
          type: File
        translated:
          doc: hyphy_results.json
          type: File
  6_HyPhy-aBSREL:
    in:
      input_file: 3_tranalign/out_file1
      input_nhx: 4_FASTTREE/output
    out:
    - absrel_output
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu_repos_iuc_hyphy_absrel_hyphy_absrel_2.5.4+galaxy0
      inputs:
        input_file:
          format: Any
          type: File
        input_nhx:
          format: Any
          type: File
      outputs:
        absrel_output:
          doc: hyphy_results.json
          type: File

