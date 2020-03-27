class: Workflow
cwlVersion: v1.2.0-dev1
doc: 'Abstract CWL generated from Galaxy workflow file: COVID-19: MCRA'
inputs:
  CoV acc date:
    format: data
    type: File
outputs: {}
steps:
  1_Remove beginning:
    in:
      input: CoV acc date
    out:
    - out_file1
    run:
      class: Operation
      id: Remove_beginning1
      inputs:
        input:
          format: Any
          type: File
      outputs:
        out_file1:
          doc: input
          type: File
  2_Convert:
    in:
      input: 1_Remove beginning/out_file1
    out:
    - out_file1
    run:
      class: Operation
      id: Convert_characters1
      inputs:
        input:
          format: Any
          type: File
      outputs:
        out_file1:
          doc: tabular
          type: File
  3_Cut:
    in:
      input: 2_Convert/out_file1
    out:
    - out_file1
    run:
      class: Operation
      id: Cut1
      inputs:
        input:
          format: Any
          type: File
      outputs:
        out_file1:
          doc: tabular
          type: File
  4_NCBI Accession Download:
    in:
      query_source|accession_file: 3_Cut/out_file1
    out:
    - output
    - error_log
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu_repos_iuc_ncbi_acc_download_ncbi_acc_download_0.2.5+galaxy0
      inputs:
        query_source|accession_file:
          format: Any
          type: File
      outputs:
        error_log:
          doc: txt
          type: File
        output:
          doc: input
          type: File
  5_NormalizeFasta:
    in:
      inputFile: 4_NCBI Accession Download/output
    out:
    - outFile
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu_repos_devteam_picard_picard_NormalizeFasta_2.18.2.1
      inputs:
        inputFile:
          format: Any
          type: File
      outputs:
        outFile:
          doc: fasta
          type: File
  6_Text transformation:
    in:
      infile: 5_NormalizeFasta/outFile
    out:
    - output
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu_repos_bgruening_text_processing_tp_sed_tool_1.1.1
      inputs:
        infile:
          format: Any
          type: File
      outputs:
        output:
          doc: input
          type: File
  7_Collapse Collection:
    in:
      input_list: 6_Text transformation/output
    out:
    - output
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu_repos_nml_collapse_collections_collapse_dataset_4.1
      inputs:
        input_list:
          format: Any
          type: File
      outputs:
        output:
          doc: input
          type: File
  8_MAFFT:
    in:
      inputSequences: 7_Collapse Collection/output
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
  9_FASTTREE:
    in:
      input_selector|input: 8_MAFFT/outputAlignment
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

