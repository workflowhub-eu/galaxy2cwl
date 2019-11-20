cwlVersion: v1.0
class: Workflow
label: Abstract CWL workflow automatically generated from a Galaxy workflow v2 file 
inputs:
  reads_1:
    type: File
    format:     ****how to retrieve type info from workflow input in .ga???

outputs:
  mapping_file:
    type: File
    outputSource: bam_output
  quality_results_html:
    type: File
    outputSource: html_file



steps:
  1:
    in:
      reads: reads_1
    out: [html_file]
    run:
      class: Operation
      id: "toolshed.g2.bx.psu.edu_repos_devteam_fastqc_fastqc_0.71_ff9530579d1f_fastqc_devteam_toolshed.g2.bx.psu.edu"
      doc: "Execute FastQC"
      inputs:
        input_file:
          type: File
          doc: #### inputs that are obtained/connected from previous steps show no type or description 
        contaminants:
	  type: 
	  doc: "runtime parameter for tool FastQC"
        limits:
	  type:
	  doc: "runtime parameter for tool FastQC"
      outputs:
        sorted:
          type: File
          doc: "The sorted file"


