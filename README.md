I use cwl-interface and cwl-abstract intercheangably here.
The idea is from https://github.com/common-workflow-language/common-workflow-language/issues/337

# This is a standalone tool that creates CWL-abstract descriptions of Galaxy workflow runs or Galaxy workflow files (static files). 


# Considerations/TODO/etc

- The idea is that if i generate a cwl-abstract file now with this then, in the future, it could be updated(as in, generating a new version) when the full galaxy-cwl is working, which will produce executable cwl descriptions. So...look carefully what and how the executable cwl is being produced from galaxy in the galaxy-cwl project (see https://github.com/common-workflow-language/galaxy)
- All steps in the CWL-abstract should have the same class ? something like  Galaxy_step, how does this affects the evolution of the generated cwl-abstract to the real ones in the future? what is it actually being printed as class in the cwl-galaxy project?
- The main thing that I should take into account to implement this is that all 3 ids (the one in the galaxy workflow file and the ones i set for cwl abstract in each case...from run or from static workflow), are the same in each step.
-Take into account the different Galaxy workflow format versions AND the CWL versions: should I create different branches for the versions/combinations.

# Examples
A simple workflow in Galaxy format can be found in examples/simple_workflow_galaxy.ga
To convert this to a CWL-interface 
The resulting CWL-interface can be found in examples/simple_workflow_cwl-interface.cwl
# External related projects:

- The main use case initially would be to create ro-crate objects for 2 cases:
    - for workflow executions: I would have the cwl-interface representing the CW:-PROV data. and also the galaxy workflow definition file? or any other info from galaxy?
    - for workflow definitions: I will have of course the workflow definition file in galaxy format, and a cwl-interface created from it.


