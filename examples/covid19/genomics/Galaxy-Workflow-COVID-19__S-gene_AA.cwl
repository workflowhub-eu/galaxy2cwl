class: Workflow
cwlVersion: v1.2.0-dev1
doc: 'Abstract CWL generated from Galaxy workflow file: COVID-19: S-gene AA'
inputs:
  0_Input Dataset:
    format: data
    type: File
outputs: {}
steps:
  1_transeq:
    in:
      input1: 0_Input Dataset
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
      input1: 0_Input Dataset
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

