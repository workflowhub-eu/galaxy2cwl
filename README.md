## here i normally use cwl-interface and cwl-abstract intercheangably. The idea is from https://github.com/common-workflow-language/common-workflow-language/issues/337

- This is a standalone that communicates with Galaxy and retrieves info from workflows definitions or worflows executions and transforms it into CWL abstract format (something like a cwl interface )

- The main use case initially would be to create ro-crate objects for 2 cases:
    - for workflow executions: I would have the cwl-interface representing the CW:-PROV data. and also the galaxy workflow definition file? or any other info from galaxy?
    - for workflow definitions: I will have of course the workflow definition file in galaxy format, and a cwl-interface created from it.
The main thing that I should take into account to implement this is that all 3 ids (the one in the galaxy workflow file and the ones i set for cwl abstract in each case), are the same in each step.
