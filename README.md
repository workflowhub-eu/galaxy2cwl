# Convert Galaxy workflow files to (abstract) CWL

- This is a standalone tool that creates CWL-abstract descriptions of Galaxy workflow runs or Galaxy workflow files (static files). 
 - Usage:
 ```
 python3 bin/get_cwl_interface.py INPUT_GALAXY_WORKFLOW(.ga/.yaml) > OUTPUT_WORKFLOW.cwl
 ```

 - The tool works with inputs in both format1 (json format .ga, currently the standard for Galaxy workflow definitions) and format2. As described in the implementation (https://github.com/galaxyproject/gxformat2), gxformat2 is 'a highly experimental format and will change rapidly in potentially backward incompatible ways until the code is merged into the Galaxy server and enabled by default' therefore the conversion to CWL from this format is also variable and can rapidly change and/or break.
 - Initially the output of this project a CWL-abstract definition (aka cwl-interface, see https://github.com/common-workflow-language/common-workflow-language/issues/337 and https://github.com/common-workflow-language/cwl-v1.2/pull/3). As the CWL support in Galaxy increases then conversion could come up with a full CWL workflow file.

## Examples
A simple workflow to use as example can be found in https://usegalaxy.eu/u/igegu/w/simple-workflow 
This workflow is available in different formats in the examples/ directory:
The Galaxy .ga format is in examples/simple_workflow_galaxy.ga
The format2 version yaml wrapped in json can be found in examples/simple_workflow_format2_yaml_wrapped.json
The format2 pure yaml in examples/simple_workflow_format2.yaml
To convert this to a CWL-interface 
The resulting CWL-interface can be found in examples/simple_workflow_cwl-interface.cwl

## Packaging with RO-Crate:
The objects created with this project are aimed to be part of workflow based RO-Crate packages. 
More information about this can be found [here](https://github.com/workflowhub-eu/about/wiki/Workflow-RO-Crate), including the templates that can be used to create metadata files.
WorkflowHub is an under development linked project that aims at, among other things, serve as a repository for workflows standardizing the metadata description. As such it provides the posibility of registering workflows in a diverse set of formats and packaging them in a RO-Crate package. 
All examples included in this project are readily available in dev.workflowhub.eu

