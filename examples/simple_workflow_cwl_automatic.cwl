class: Workflow
cwlVersion: v1.2
inputs:
  0/output:
    format: Input files have no info about format
    type: File ... need to retrieve more info
label: Abstract CWL workflow automatically generated from a Galaxy .ga version 2 file
outputs:
  1/html_file:
    outputSource: 1/html_file
    type: File ....should be able to get more info
  3/bam_output:
    outputSource: 3/bam_output
    type: File ....should be able to get more info
steps:
  '1':
    in:
      input_file: 0/output
    out:
    - html_file
    run:
      class: Operation
      doc: Execute FastQC
      id: toolshed.g2.bx.psu.edu/repos/devteam/fastqc/fastqc/0.71_fastqc_ff9530579d1f_devteam_toolshed.g2.bx.psu.edu
      inputs:
        contaminants:
          doc: runtime parameter for tool FastQC
          type: File
        input_file:
          doc: Connected inputs have no description in the .ga file
          type: File -- I have no info about file type
        limits:
          doc: runtime parameter for tool FastQC
          type: File
      outputs:
        html_file:
          doc:
            name: html_file
            type: html
          type: html
        text_file:
          doc:
            name: text_file
            type: txt
          type: txt
  '2':
    in:
      singlePaired|input_singles: 0/output
    out: []
    run:
      class: Operation
      doc: Execute Trim Galore!
      id: toolshed.g2.bx.psu.edu/repos/bgruening/trim_galore/trim_galore/0.4.3.1_trim_galore_949f01671246_bgruening_toolshed.g2.bx.psu.edu
      inputs:
        singlePaired:
          doc: runtime parameter for tool Trim Galore!
          type: File
        singlePaired|input_singles:
          doc: Connected inputs have no description in the .ga file
          type: File -- I have no info about file type
      outputs:
        trimmed_reads_single:
          doc:
            name: trimmed_reads_single
            type: input
          type: input
  '3':
    in:
      fastq_input|fastq_input1: 2/trimmed_reads_single
    out:
    - bam_output
    run:
      class: Operation
      doc: Execute Map with BWA-MEM
      id: toolshed.g2.bx.psu.edu/repos/devteam/bwa/bwa_mem/0.7.17.1_bwa_dfd8b7f78c37_devteam_toolshed.g2.bx.psu.edu
      inputs:
        fastq_input:
          doc: runtime parameter for tool Map with BWA-MEM
          type: File
        fastq_input|fastq_input1:
          doc: Connected inputs have no description in the .ga file
          type: File -- I have no info about file type
      outputs:
        bam_output:
          doc:
            name: bam_output
            type: bam
          type: bam

