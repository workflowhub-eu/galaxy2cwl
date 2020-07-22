# Convert Galaxy workflow files to (abstract) CWL

This is a standalone tool that creates CWL-abstract descriptions of Galaxy workflow runs or Galaxy workflow files (static files). 

 - Usage:
 ```
 galaxy2cwl INPUT_GALAXY_WORKFLOW(.ga/.yaml) > OUTPUT_WORKFLOW.cwl
 ```
 - The tool works with inputs in both format1 (json format .ga, currently the standard for Galaxy workflow definitions) and format2. As described in the implementation (https://github.com/galaxyproject/gxformat2), gxformat2 is 'a highly experimental format and will change rapidly in potentially backward incompatible ways until the code is merged into the Galaxy server and enabled by default' therefore the conversion to CWL from this format is also variable and can rapidly change and/or break.
 - Initially the output of this project a CWL-abstract definition (aka cwl-interface, see https://github.com/common-workflow-language/common-workflow-language/issues/337 and https://github.com/common-workflow-language/cwl-v1.2/pull/3). As the CWL support in Galaxy increases then conversion could come up with a full CWL workflow file.

## License

* Copyright © 2019-2020, Ignacio Eguinoa, VIB, Universiteit Gent, and workflowhub.eu contributors

Distributed under a [BSD 3-Clause license](https://github.com/workflowhub-eu/cwl-from-galaxy/blob/master/LICENSE).

## Installing from source

This library is easiest to install using pip:
    
    pip install galaxy2cwl

If you want to install manually from this code base, then try:
    
    pip3 install .

or, assuming all dependencies are installed:

    python setup.py install

This should install `cwl2galaxy` on your PATH. 

Alternatively you can run `python3 galaxy2cwl/get_cwl_interface.py` directly.

<!--  

### Release procedure

vim setup.py ## update: version = "0.1.2",
git commit -m "Release 0.1.2" setup.py
git tag 0.1.2
rm dist/*
python3 setup.py clean
python3 setup.py bdist_wheel
twine upload --repository testpypi dist/*   ## for testing
twine upload dist/*   ## if above is OK

vim setup.py ## prepare for next:  version = "0.1.3-dev",
git commit -m "Prepare for 0.1.3" setup.py
git push --tags
git push

See also https://packaging.python.org/tutorials/packaging-projects/
in ~/.pypirc have tokens for both pypi and testpypi:

(base) stain@biggie:~/src/cwl-from-galaxy$ cat ~/.pypirc 
[pypi]
  username = __token__
  password = pypi-abcdREPLACEME

[distutils]
index-servers=
    pypi
    testpypi

[testpypi]
repository: https://test.pypi.org/legacy/
username: __token__
password: pypi-abcdREPLACEME
-->

## Examples
A simple workflow to use as example can be found in <https://usegalaxy.eu/u/igegu/w/simple-workflow>

This workflow is available in different formats in the [examples/ directory](https://github.com/workflowhub-eu/galaxy2cwl/tree/master/examples) of the source repository.

* The Galaxy .ga format is in `examples/simple_workflow_galaxy.ga`
* The format2 version yaml wrapped in json can be found in `examples/simple_workflow_format2_yaml_wrapped.json`
* The format2 pure yaml in `examples/simple_workflow_format2.yaml`
* The resulting CWL-interface can be found in `examples/simple_workflow_cwl-interface.cwl`

## Packaging with RO-Crate

The objects created with this project are aimed to be part of [workflow based RO-Crate](https://github.com/workflowhub-eu/about/wiki/Workflow-RO-Crate) packages for registering in _WorkflowHub_.

[WorkflowHub](https://about.workflowhub.eu/) is a project under development that aims at, among other things, serve as a repository for workflows standardizing the metadata description. 

As such it provides the possibility of registering workflows in a diverse set of formats and packaging them in a RO-Crate package. 

All examples included in this project are readily available in <https://dev.workflowhub.eu/>

## Contribute

Contributions welcome! Raise pull requests, issues etc on <https://github.com/workflowhub-eu/galaxy2cwl/>.

Submitted patches are assumed to be licensed under the same BSD 3-Clause license.
