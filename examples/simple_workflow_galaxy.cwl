class: Workflow
cwlVersion: v1.2.0-dev2
doc: 'Abstract CWL Automatically generated from the Galaxy workflow file: Simple workflow'
inputs:
  reads_1:
    format: data
    type: File
outputs: {}
steps:
  1_FastQC:
    in:
      input_file: reads_1
    out:
    - html_file
    - text_file
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_devteam_fastqc_fastqc_0_71
      inputs:
        input_file:
          format: Any
          type: File
      outputs:
        html_file:
          doc: html
          type: File
        text_file:
          doc: txt
          type: File
  2_Trim Galore!:
    in:
      singlePaired|input_singles: reads_1
    out:
    - trimmed_reads_single
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_bgruening_trim_galore_trim_galore_0_4_3_1
      inputs:
        singlePaired|input_singles:
          format: Any
          type: File
      outputs:
        trimmed_reads_single:
          doc: input
          type: File
  3_Map with BWA-MEM:
    in:
      fastq_input|fastq_input1: 2_Trim Galore!/trimmed_reads_single
    out:
    - bam_output
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_devteam_bwa_bwa_mem_0_7_17_1
      inputs:
        fastq_input|fastq_input1:
          format: Any
          type: File
      outputs:
        bam_output:
          doc: bam
          type: File

