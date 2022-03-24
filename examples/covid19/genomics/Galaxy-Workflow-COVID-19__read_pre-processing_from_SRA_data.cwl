class: Workflow
cwlVersion: v1.2
doc: 'Abstract CWL Automatically generated from the Galaxy workflow file: COVID-19:
  read pre-processing from SRA data'
inputs:
  Illumina dataset collection:
    format: data
    type: File
  ONT dataset collection:
    format: data
    type: File
outputs: {}
steps:
  10_Filter SAM or BAM, output SAM or BAM:
    in:
      input1: 7_Map with BWA-MEM/bam_output
    out:
    - output1
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_devteam_samtool_filter2_samtool_filter2_1_8+galaxy1
      inputs:
        input1:
          format: Any
          type: File
      outputs:
        output1:
          doc: sam
          type: File
  11_MergeSamFiles:
    in:
      inputFile: 9_Filter SAM or BAM, output SAM or BAM/output1
    out:
    - outFile
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_devteam_picard_picard_MergeSamFiles_2_18_2_1
      inputs:
        inputFile:
          format: Any
          type: File
      outputs:
        outFile:
          doc: bam
          type: File
  12_MergeSamFiles:
    in:
      inputFile: 10_Filter SAM or BAM, output SAM or BAM/output1
    out:
    - outFile
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_devteam_picard_picard_MergeSamFiles_2_18_2_1
      inputs:
        inputFile:
          format: Any
          type: File
      outputs:
        outFile:
          doc: bam
          type: File
  13_Samtools fastx:
    in:
      input: 11_MergeSamFiles/outFile
    out:
    - nonspecific
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_samtools_fastx_samtools_fastx_1_9+galaxy1
      inputs:
        input:
          format: Any
          type: File
      outputs:
        nonspecific:
          doc: fasta
          type: File
  14_Samtools fastx:
    in:
      input: 12_MergeSamFiles/outFile
    out:
    - forward
    - reverse
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_samtools_fastx_samtools_fastx_1_9+galaxy1
      inputs:
        input:
          format: Any
          type: File
      outputs:
        forward:
          doc: fasta
          type: File
        reverse:
          doc: fasta
          type: File
  2_fastp:
    in:
      single_paired|paired_input: Illumina dataset collection
    out:
    - output_paired_coll
    - report_html
    - report_json
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_fastp_fastp_0_19_5+galaxy1
      inputs:
        single_paired|paired_input:
          format: Any
          type: File
      outputs:
        output_paired_coll:
          doc: input
          type: File
        report_html:
          doc: html
          type: File
        report_json:
          doc: json
          type: File
  3_NanoPlot:
    in:
      mode|reads|files: ONT dataset collection
    out:
    - output_html
    - nanostats
    - nanostats_post_filtering
    - read_length
    - log_read_length
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_nanoplot_nanoplot_1_25_0+galaxy1
      inputs:
        mode|reads|files:
          format: Any
          type: File
      outputs:
        log_read_length:
          doc: png
          type: File
        nanostats:
          doc: txt
          type: File
        nanostats_post_filtering:
          doc: txt
          type: File
        output_html:
          doc: html
          type: File
        read_length:
          doc: png
          type: File
  4_FastQC:
    in:
      input_file: ONT dataset collection
    out:
    - html_file
    - text_file
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_devteam_fastqc_fastqc_0_72+galaxy1
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
  5_Map with minimap2:
    in:
      fastq_input|fastq_input1: ONT dataset collection
    out:
    - alignment_output
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_minimap2_minimap2_2_17+galaxy0
      inputs:
        fastq_input|fastq_input1:
          format: Any
          type: File
      outputs:
        alignment_output:
          doc: bam
          type: File
  6_MultiQC:
    in:
      results_0|software_cond|input: 2_fastp/report_json
    out:
    - stats
    - html_report
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_multiqc_multiqc_1_7
      inputs:
        results_0|software_cond|input:
          format: Any
          type: File
      outputs:
        html_report:
          doc: html
          type: File
        stats:
          doc: input
          type: File
  7_Map with BWA-MEM:
    in:
      fastq_input|fastq_input1: 2_fastp/output_paired_coll
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
  8_MultiQC:
    in:
      results_0|software_cond|output_0|input: 4_FastQC/text_file
    out:
    - stats
    - html_report
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_multiqc_multiqc_1_7
      inputs:
        results_0|software_cond|output_0|input:
          format: Any
          type: File
      outputs:
        html_report:
          doc: html
          type: File
        stats:
          doc: input
          type: File
  9_Filter SAM or BAM, output SAM or BAM:
    in:
      input1: 5_Map with minimap2/alignment_output
    out:
    - output1
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_devteam_samtool_filter2_samtool_filter2_1_8+galaxy1
      inputs:
        input1:
          format: Any
          type: File
      outputs:
        output1:
          doc: sam
          type: File

