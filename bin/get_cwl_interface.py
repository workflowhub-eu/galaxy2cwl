import yaml
#import json
import sys
# import pprint
import json


def try_as(loader, s, on_error):
    try:
        loader(s)
        return True
    except on_error:
        return False

def is_json(s):
    return try_as(json.loads, s, ValueError)

def is_yaml(s):
    return try_as(yaml.safe_load, s, yaml.scanner.ScannerError)



def process_format1_json(wf_dict):
    wf_inputs={}
    wf_outputs={}
    steps={}
    wf_name = wf_dict['name']
    cwl_doc= 'Abstract CWL generated from Galaxy: ' + wf_name
    cwl_out={}
    map_output_to_in_name= {}  # map formal names to labelled/renamed
    step_index_map = {}  # map step index num with full step names 
    #iterate over input steps
    for step_index, step_details in wf_dict['steps'].items():
        if step_details['type'] == 'data_input':
            #user data input
            input_details = {}
            input_details['format'] = 'data'
            input_details['type'] = 'File'
            # ok to assume there is only 1 input per data_input step ?
            input_name = step_details['inputs'][0]['name']
            if step_details['inputs'][0]['description'] != '':
                input_details['doc']= step_details['inputs'][0]['description']
            # why some input_data steps don't have workflow_outputs lists defined ?
            if len(step_details['workflow_outputs']) > 0:
                output_name = step_details['workflow_outputs'][0]['output_name']
            else:
                output_name = 'output'
            map_output_to_in_name[step_index + '_' + output_name] = input_name
            wf_inputs[input_name] = input_details
        else:
            step_name = step_details['name']
            step_index_map[str(step_index)] = step_index + '_' + step_name
    # iterate over tool steps
    for step_index, step_details in wf_dict['steps'].items():
        if step_details['type'] != 'data_input':
            step_cwl_entry = {}
            step_run_dict = {}
            step_run_dict['class'] = 'Operation'
            step_run_dict['id'] = step_details['tool_id']
            step_class_outputs = {}   #dict inside the run object
            step_class_inputs = {} # dict inside the run  object
            step_wf_out = []  # list associated to out key
            step_wf_in = {}
            step_name = step_index + '_' + step_details['name']
            for input_name,input_details in step_details['input_connections'].items():
                source_output_name = input_details['output_name']
                source_output_name_canon = str(input_details['id']) + '_' + source_output_name
                source_index = input_details['id']
                # get the source step id
                if str(source_index) not in step_index_map.keys():  # does not belong to a previous tool but to a users input
                    step_wf_in[input_name] = map_output_to_in_name[source_output_name_canon]
                else: # input connected to other tool output
                    # get the source output name ()
                    # out_name_canon = step_index + '_' + source_output_name
                    source_step_name = step_index_map[str(source_index)]
                    step_wf_in[input_name] = source_step_name + '/' + source_output_name
                step_class_inputs[input_name] = {'format':'Any', 'type':'File'}  #TODO: can add more metadata on this? replicate the info from the source step?

            # step_cwl_entry['run'] = step_run
            step_run_dict['inputs'] = step_class_inputs
            step_cwl_entry['in'] = step_wf_in
            steps[step_name] = step_cwl_entry

            #iterate over outputs
            for output in step_details['outputs']:
                step_wf_out.append(output['name'])
                step_class_outputs[output['name']] = {'type': 'File' , 'doc': output['type']}   ## ideally I should map Galaxy types to CWLType 
            step_run_dict['outputs'] = step_class_outputs
            step_cwl_entry['run'] = step_run_dict
            step_cwl_entry['out'] = step_wf_out
    cwl_out['steps']=steps
    cwl_out['cwlVersion']='v1.2.0-dev1'
    cwl_out['class']='Workflow'
    cwl_out['doc']=cwl_doc
    cwl_out['inputs']=wf_inputs
    cwl_out['outputs']=wf_outputs
    return cwl_out

## NOT USED: converting format1 to format2 is not totally reliable.
# if wf_class != "GalaxyWorkflow" and "yaml_content" not in wf_dict:  # format2 options
    # import gxformat2
    # wf_dict=gxformat2.from_galaxy_native(wf_dict)



def process_format2_yaml(wf_dict):
    wf_inputs={}
    wf_outputs={}
    steps={}
    wf_label=wf_dict['label']
    cwl_doc= 'Abstract CWL generated from Galaxy: ' + wf_label
    global_outputs = {}
    full_source_names_dict = {}
    input_steps_count = 0 # count the number of steps that would belong to input from the user. These are not listed in the workflow steps but are relevant to keep track of step index numbers
    for input_entry in wf_dict['inputs']:
        input_details={}
        input_details['type']='File'
        input_details['format']=wf_dict['inputs'][input_entry]['type']
        wf_inputs[input_entry]=input_details
    for output in wf_dict['outputs']:
        if wf_dict['outputs'][output]['outputSource'] not in wf_inputs.keys():
            output_details={}
            output_details['type']='File'
            output_details['outputSource']=wf_dict['outputs'][output]['outputSource']
            step_num,out_name= wf_dict['outputs'][output]['outputSource'].split('/')
            ## TODO refactor this step to check what kind of source step it is
            if step_num.isdigit():   # the source references a step index
                step_num = str(step_num)
            else:
                step_num = step_num.replace(':', ' -')
            if step_num in global_outputs.keys():
                global_outputs[step_num].append(out_name)
            else:
                global_outputs[step_num]=[out_name]
            wf_outputs[output]=output_details
        else:
            input_steps_count += 1
    # first iteration over the steps, just to get the step_name right and fill in full_source_nameS_dict
    for (step_index,step) in enumerate(wf_dict['steps']):
        corrected_step_index = str(step_index + input_steps_count)
        if 'label' not in step.keys():
            step_name = corrected_step_index + '_' + step['tool_id'].replace('/', '_')  #step['tool_shed_repository']['name']
        else:
            step_name = step['label'].replace(':',' -')
            full_source_names_dict[step_name] = step_name
        full_source_names_dict[corrected_step_index] = step_name
    # now iterate again and process each step inputs/outputs/... 
    for (step_index,step) in enumerate(wf_dict['steps']):
        step_details = {}
        step_public_out_list = []
        corrected_step_index = str(step_index + input_steps_count)
        if 'label' not in step.keys():
            step_name = corrected_step_index + '_' + step['tool_id'].replace('/', '_')  #step['tool_shed_repository']['name']
        else:
            step_name = step['label'].replace(':', ' -')
        # this should be stored in a gobal dict of tools runs. if a workflow calls a tool several times then its refactored somewhere else (maybe even another file)
        step_run = {}
        step_run['class'] = 'Operation'
        step_run['id'] = step['tool_id'].replace('/', '_')  ## TODO: refactor sanitization of  / and : 
        step_run['doc'] = "Execute "+ step_name
        # add step inputs
        step_inputs={}
        step_connection_inputs = {}  ## the inputs that are from step connections
        for step_in in step['in']:
            step_in_details={}
            # step_in_details['source']=step['in'][step_in]['source']
            if step['in'][step_in]['source'] not in wf_inputs.keys():
                step_num,out_name = step['in'][step_in]['source'].split('/')
                if step_num.isdigit():   # the source references a step index
                    step_num = str(step_num)
                else:
                    step_num = step_num.replace(':', ' -')
                full_source_name = full_source_names_dict[step_num]
                step_connection_inputs[step_in] = full_source_name + '/' + out_name
            else:
                full_source_name = step['in'][step_in]['source']
                step_connection_inputs[step_in] = full_source_name

            step_in_details['type']='File'   ## Operation inputs and outputs MUST have a type
            step_in_details['format']='Any' #Need to complete from tool info'   ## Operation inputs and outputs SHOULD have a format and doc
            # step_in_details['doc']='Need to complete from tool info'   ## Operation inputs and outputs SHOULD have a format and doc
            step_inputs[step_in]=step_in_details
        step_run['inputs'] = step_inputs
        step_details['in'] = step_connection_inputs

        # step outputs
        step_outputs_list=[]
        step_outputs={} # detailed dictionary of each output
        if 'out' in step:
            for step_out in step['out']:
                step_out_details={}
                step_out_details['type']='File' ## Operation inputs and outputs MUST have a type
                #step_out_details['doc']='Need to complete from tool info'  ## Operation inputs and outputs SHOULD have a format and doc
                #step_out_details['format']='Need to complete from tool info' ## Operation inputs and outputs SHOULD have a format and doc
                #step_out_details['outputSource']=         Not sure this makes sense to include
                step_outputs[step_out]=step_out_details
                step_outputs_list.append(step_out)
                step_public_out_list.append(step_out)
        if corrected_step_index in global_outputs.keys():
            for global_out in global_outputs[corrected_step_index]:
                step_out_details = {}
                step_out_details['type']='File' ## Operation inputs and outputs MUST have a type
                #step_out_details['doc']='Need to complete from tool info'  ## Operation inputs and outputs SHOULD have a format and doc
                #step_out_details['format']='Need to complete from tool info' ## Operation inputs and outputs SHOULD have a format and doc
                #step_out_details['outputSource']=         Not sure this makes sense to include
                step_outputs[global_out]=step_out_details
                step_outputs_list.append(global_out)
                #print(global_out)
                step_public_out_list.append(global_out)
        if step_name in global_outputs.keys():
            for global_out in global_outputs[step_name]:
                step_out_details = {}
                step_out_details['type']='File' ## Operation inputs and outputs MUST have a type
                #step_out_details['doc']='Need to complete from tool info'  ## Operation inputs and outputs SHOULD have a format and doc
                #step_out_details['format']='Need to complete from tool info' ## Operation inputs and outputs SHOULD have a format and doc
                #step_out_details['outputSource']=         Not sure this makes sense to include
                step_outputs[global_out]=step_out_details
                step_outputs_list.append(global_out)
                #print(global_out)
                step_public_out_list.append(global_out)
        step_run['outputs']=step_outputs
        ## add the step to the list
        step_details['run'] = step_run
        step_details['out'] = step_public_out_list
        steps[step_name]=step_details
    for output in wf_dict['outputs']:
        if wf_dict['outputs'][output]['outputSource'] not in wf_inputs.keys():
            output_details={}
            output_details['type']='File'
            step_num,out_name= wf_dict['outputs'][output]['outputSource'].split('/')
            if step_num.isdigit():   # the source references a step index
                step_num = str(step_num)
            else:
                step_num = step_num.replace(':', ' -')
            full_source_name = full_source_names_dict[step_num]
            output_details['outputSource']=full_source_name + '/' + out_name
            wf_outputs[output]=output_details
    cwl_out={}
    cwl_out['steps']=steps
    cwl_out['cwlVersion']='v1.2.0-dev1'
    cwl_out['class']='Workflow'
    cwl_out['doc']=cwl_doc
    cwl_out['inputs']=wf_inputs
    cwl_out['outputs']=wf_outputs
    return cwl_out

if __name__ == '__main__':
    if is_json(open(sys.argv[1]).read()):
        wf_dict = json.loads(open(sys.argv[1]).read())
        if "yaml_content" in wf_dict:
            # need to first extract 
            wf_dict = yaml.safe_load(wf_dict['yaml_content'])
            cwl_out = process_format2_yaml(wf_dict)
        else:
            if wf_dict['a_galaxy_workflow'] == 'true':
                cwl_out = process_format1_json(wf_dict)
    else:
        if is_yaml(open(sys.argv[1])):
            wf_dict = yaml.safe_load(open(sys.argv[1]))
            wf_class = wf_dict.get("class", None)
            if wf_class == "GalaxyWorkflow":
                cwl_out = process_format2_yaml(wf_dict)
            else:
                print('Error processing file: Incorrect format')
                sys.exit()
    print(yaml.dump(cwl_out))
