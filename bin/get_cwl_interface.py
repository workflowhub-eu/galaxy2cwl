import yaml
#import json
import sys
# import pprint


# load the workflow in a dict
wf_dict=yaml.safe_load(open(sys.argv[1]))
## TODO CHECK IF THE INPUT IS INDEED A WORKFLOW


wf_inputs={}
wf_outputs={}
steps={}
cwl_out={}

wf_class=wf_dict.get("class", None)


if wf_class != "GalaxyWorkflow" and "yaml_content" not in wf_dict:  # format2 options
    import gxformat2
    wf_dict=gxformat2.from_galaxy_native(wf_dict)

# check again that the format is correct 
wf_class=wf_dict.get("class", None)
if wf_class == "GalaxyWorkflow" or "yaml_content" in wf_dict: # min check for format2
    if "yaml_content" in wf_dict:
        # need to first extract 
        wf_dict=yaml.safe_load(wf_dict['yaml_content'])
    wf_label=wf_dict['label']
    cwl_doc= 'Abstract CWL generated from Galaxy: ' + wf_label
    for output in wf_dict['outputs']:
        output_details={}
        output_details['type']='File'
        output_details['outputSource']=wf_dict['outputs'][output]['outputSource']
        wf_outputs[output]=output_details
    for input_entry in wf_dict['inputs']:
        input_details={}
        input_details['type']='File ... need to retrieve more info'
        input_details['format']=wf_dict['inputs'][input_entry]['type']
        wf_inputs[input_entry]=input_details
    for (step_index,step) in enumerate(wf_dict['steps']):
        step_details={}
        step_name=step['tool_shed_repository']['name']
        step_details['class']='Operation'
        step_details['id']=step['tool_id']
        step_details['doc']="Execute "+ step_name
        # add step inputs
        step_inputs={}
        for step_in in step['in']:
            step_in_details={}
            step_in_details['source']=step['in'][step_in]['source']
            step_in_details['type']='File'   ## Operation inputs and outputs MUST have a type
            step_in_details['format']='Need to complete from tool info'   ## Operation inputs and outputs SHOULD have a format and doc
            step_in_details['doc']='Need to complete from tool info'   ## Operation inputs and outputs SHOULD have a format and doc
            step_inputs[step_in]=step_in_details
        step_details['inputs']=step_inputs

        # step outputs
        step_outputs_list=[]
        step_outputs={} # detailed dictionary of each output
        if 'out' in step:
            for step_out in step['out']:
                step_out_details={}
                step_out_details['type']='File' ## Operation inputs and outputs MUST have a type
                step_out_details['doc']='Need to complete from tool info'  ## Operation inputs and outputs SHOULD have a format and doc
                step_out_details['format']='Need to complete from tool info' ## Operation inputs and outputs SHOULD have a format and doc
                #step_out_details['outputSource']=         Not sure this makes sense to include
                step_outputs[step_out]=step_out_details
                step_outputs_list.append(step_out)
        step_details['outputs']=step_outputs
        ## add the step to the list
        steps[step_name]=step_details


else:
    print("Format does not belong to any Galaxy workflow formats")
    sys.exit()


cwl_out['steps']=steps
cwl_out['cwlVersion']='v1.2.0-dev2'
cwl_out['class']='Workflow'
cwl_out['doc']=cwl_doc
cwl_out['inputs']=wf_inputs
cwl_out['outputs']=wf_outputs
print(yaml.dump(cwl_out))
