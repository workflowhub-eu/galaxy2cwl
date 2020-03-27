class: Workflow
cwlVersion: v1.2.0-dev1
doc: 'Abstract CWL generated from Galaxy: COVID-19: SE Variation'
inputs:
  0_Input Dataset Collection:
    format: data
    type: File
  NC_045512:
    format: data
    type: File
outputs: {}
steps:
  10_Call variants:
    in:
      reads: 9_Realign reads/realigned
      reference_source|ref: 3_SnpEff build/output_fasta
    out:
    - variants
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/iuc/lofreq_call/lofreq_call/2.1.3.1+galaxy1
      inputs:
        reads:
          format: Any
          type: File
        reference_source|ref:
          format: Any
          type: File
      outputs:
        variants:
          doc: vcf
          type: File
  11_SnpEff eff:
    in:
      input: 10_Call variants/variants
      snpDb|snpeff_db: 3_SnpEff build/snpeff_output
    out:
    - snpeff_output
    - statsFile
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/iuc/snpeff/snpEff/4.3+T.galaxy1
      inputs:
        input:
          format: Any
          type: File
        snpDb|snpeff_db:
          format: Any
          type: File
      outputs:
        snpeff_output:
          doc: vcf
          type: File
        statsFile:
          doc: html
          type: File
  12_SnpSift Extract Fields:
    in:
      input: 11_SnpEff eff/snpeff_output
    out:
    - output
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/iuc/snpsift/snpSift_extractFields/4.3+t.galaxy0
      inputs:
        input:
          format: Any
          type: File
      outputs:
        output:
          doc: tabular
          type: File
  13_Collapse Collection:
    in:
      input_list: 12_SnpSift Extract Fields/output
    out:
    - output
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/nml/collapse_collections/collapse_dataset/4.1
      inputs:
        input_list:
          format: Any
          type: File
      outputs:
        output:
          doc: input
          type: File
  2_fastp:
    in:
      single_paired|in1: 0_Input Dataset Collection
    out:
    - out1
    - report_html
    - report_json
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/iuc/fastp/fastp/0.19.5+galaxy1
      inputs:
        single_paired|in1:
          format: Any
          type: File
      outputs:
        out1:
          doc: input
          type: File
        report_html:
          doc: html
          type: File
        report_json:
          doc: json
          type: File
  3_SnpEff build:
    in:
      input_type|input_gbk: NC_045512
    out:
    - snpeff_output
    - output_fasta
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/iuc/snpeff/snpEff_build_gb/4.3+T.galaxy4
      inputs:
        input_type|input_gbk:
          format: Any
          type: File
      outputs:
        output_fasta:
          doc: fasta
          type: File
        snpeff_output:
          doc: snpeffdb
          type: File
  4_MultiQC:
    in:
      results_0|software_cond|input: 2_fastp/report_json
    out:
    - stats
    - plots
    - html_report
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/iuc/multiqc/multiqc/1.7.1
      inputs:
        results_0|software_cond|input:
          format: Any
          type: File
      outputs:
        html_report:
          doc: html
          type: File
        plots:
          doc: input
          type: File
        stats:
          doc: input
          type: File
  5_Bowtie2:
    in:
      library|input_1: 2_fastp/out1
      reference_genome|own_file: 3_SnpEff build/output_fasta
    out:
    - output
    - mapping_stats
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/devteam/bowtie2/bowtie2/2.3.4.3+galaxy0
      inputs:
        library|input_1:
          format: Any
          type: File
        reference_genome|own_file:
          format: Any
          type: File
      outputs:
        mapping_stats:
          doc: txt
          type: File
        output:
          doc: bam
          type: File
  6_MultiQC:
    in:
      results_0|software_cond|input: 5_Bowtie2/mapping_stats
    out:
    - stats
    - plots
    - html_report
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/iuc/multiqc/multiqc/1.7.1
      inputs:
        results_0|software_cond|input:
          format: Any
          type: File
      outputs:
        html_report:
          doc: html
          type: File
        plots:
          doc: input
          type: File
        stats:
          doc: input
          type: File
  7_MarkDuplicates:
    in:
      inputFile: 5_Bowtie2/output
    out:
    - metrics_file
    - outFile
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/devteam/picard/picard_MarkDuplicates/2.18.2.2
      inputs:
        inputFile:
          format: Any
          type: File
      outputs:
        metrics_file:
          doc: txt
          type: File
        outFile:
          doc: bam
          type: File
  8_MultiQC:
    in:
      results_0|software_cond|output_0|input: 7_MarkDuplicates/metrics_file
    out:
    - stats
    - plots
    - html_report
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/iuc/multiqc/multiqc/1.7.1
      inputs:
        results_0|software_cond|output_0|input:
          format: Any
          type: File
      outputs:
        html_report:
          doc: html
          type: File
        plots:
          doc: input
          type: File
        stats:
          doc: input
          type: File
  9_Realign reads:
    in:
      reads: 7_MarkDuplicates/outFile
      reference_source|ref: 3_SnpEff build/output_fasta
    out:
    - realigned
    run:
      class: Operation
      id: toolshed.g2.bx.psu.edu/repos/iuc/lofreq_viterbi/lofreq_viterbi/2.1.3.1+galaxy1
      inputs:
        reads:
          format: Any
          type: File
        reference_source|ref:
          format: Any
          type: File
      outputs:
        realigned:
          doc: bam
          type: File

