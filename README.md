# Convert Galaxy workflow files to (abstract) CWL

- This is a standalone tool that creates CWL-abstract descriptions of Galaxy workflow runs or Galaxy workflow files (static files). 
- Initially the output will be an abstract version of a CWL workflow (aka cwl-interface, see https://github.com/common-workflow-language/common-workflow-language/issues/337 and https://github.com/common-workflow-language/cwl-v1.2/pull/3). As the CWL support in Galaxy increases then conversion could come up with a full CWL workflow file.


## Examples
A simple workflow to use as example can be found in https://usegalaxy.eu/u/igegu/w/simple-workflow 
This workflow is available in different formats in the examples/ directory:
The Galaxy .ga format is in examples/simple_workflow_galaxy.ga
The format2 version yaml wrapped in json can be found in examples/simple_workflow_format2_yaml_wrapped.json
The format2 pure yaml in examples/simple_workflow_format2.yaml
To convert this to a CWL-interface 
The resulting CWL-interface can be found in examples/simple_workflow_cwl-interface.cwl

## External related projects:
- The main use case initially would be to create ro-crate objects for 2 cases:
    - for workflow executions: I would have the cwl-interface representing the CW:-PROV data. and also the galaxy workflow definition file? or any other info from galaxy?
    - for workflow definitions: I will have of course the workflow definition file in galaxy format, and a cwl-interface created from it.


