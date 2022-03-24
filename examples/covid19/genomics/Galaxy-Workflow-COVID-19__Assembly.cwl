class: Workflow
cwlVersion: v1.2
doc: 'Abstract CWL Automatically generated from the Galaxy workflow file: COVID-19:
  Assembly'
inputs:
  Forward reads:
    format: data
    type: File
  ONT reads:
    format: data
    type: File
  Reverse reads:
    format: data
    type: File
outputs: {}
steps:
  3_Create assemblies with Unicycler:
    in:
      long: ONT reads
      paired_unpaired|fastq_input1: Forward reads
      paired_unpaired|fastq_input2: Reverse reads
    out:
    - assembly_graph
    - assembly
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_unicycler_unicycler_0_4_8_0
      inputs:
        long:
          format: Any
          type: File
        paired_unpaired|fastq_input1:
          format: Any
          type: File
        paired_unpaired|fastq_input2:
          format: Any
          type: File
      outputs:
        assembly:
          doc: fasta
          type: File
        assembly_graph:
          doc: tabular
          type: File
  4_SPAdes:
    in:
      libraries_0|files_0|file_type|fwd_reads: Forward reads
      libraries_0|files_0|file_type|rev_reads: Reverse reads
      nanopore_reads: ONT reads
    out:
    - out_contig_stats
    - out_scaffold_stats
    - out_contigs
    - out_scaffolds
    - out_log
    - contig_graph
    - scaffold_graph
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_nml_spades_spades_3_12_0+galaxy1
      inputs:
        libraries_0|files_0|file_type|fwd_reads:
          format: Any
          type: File
        libraries_0|files_0|file_type|rev_reads:
          format: Any
          type: File
        nanopore_reads:
          format: Any
          type: File
      outputs:
        contig_graph:
          doc: txt
          type: File
        out_contig_stats:
          doc: tabular
          type: File
        out_contigs:
          doc: fasta
          type: File
        out_log:
          doc: txt
          type: File
        out_scaffold_stats:
          doc: tabular
          type: File
        out_scaffolds:
          doc: fasta
          type: File
        scaffold_graph:
          doc: txt
          type: File
  5_Bandage Info:
    in:
      input_file: 3_Create assemblies with Unicycler/assembly_graph
    out:
    - outfile
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_bandage_bandage_info_0_8_1+galaxy1
      inputs:
        input_file:
          format: Any
          type: File
      outputs:
        outfile:
          doc: txt
          type: File
  6_Bandage Image:
    in:
      input_file: 3_Create assemblies with Unicycler/assembly_graph
    out:
    - outfile
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_bandage_bandage_image_0_8_1+galaxy2
      inputs:
        input_file:
          format: Any
          type: File
      outputs:
        outfile:
          doc: jpg
          type: File
  7_Bandage Image:
    in:
      input_file: 4_SPAdes/contig_graph
    out:
    - outfile
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_bandage_bandage_image_0_8_1+galaxy2
      inputs:
        input_file:
          format: Any
          type: File
      outputs:
        outfile:
          doc: jpg
          type: File
  8_Bandage Info:
    in:
      input_file: 4_SPAdes/contig_graph
    out:
    - outfile
    run:
      class: Operation
      id: toolshed_g2_bx_psu_edu_repos_iuc_bandage_bandage_info_0_8_1+galaxy1
      inputs:
        input_file:
          format: Any
          type: File
      outputs:
        outfile:
          doc: txt
          type: File

