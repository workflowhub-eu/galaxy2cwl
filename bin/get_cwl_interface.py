import yaml
#import json
import sys



# load the workflow in a dict
wf_dict=yaml.safe_load(open(sys.argv[1]))
#print(type(wf_dict))
## TODO CHECK IF THE INPUT WAS INDEED A WORKFLOW


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
    cwl_label='Abstract CWL workflow automatically generated from a Galaxy format2 workflow file'
    #print(wf_dict)
    for output in wf_dict['outputs']:
        output_details={}
        output_details['type']='File ... need to retrieve more info'
        output_details['outputSource']=wf_dict['outputs'][output]['outputSource']
        wf_outputs[output]=output_details
    for input_entry in wf_dict['inputs']:
        input_details={}
        input_details['type']='File ... need to retrieve more info'
        input_details['format']=wf_dict['inputs'][input_entry]['type']
        wf_inputs[input_entry]=input_details
    for (step_index,step) in enumerate(wf_dict['steps']):
        #print(step['tool_shed_repository']['name'])
        step_details={}
        step_name=step['tool_shed_repository']['name']
        run_dict={}
        #run_dict['inputs']=step_inputs
        #run_dict['outputs']=step_outputs
        run_dict['class']='Operation'
        run_dict['id']=step['tool_id']
        run_dict['doc']="Execute "+ step_name
        step_details['run']=run_dict



        ## add the step to the list
        steps[step_name]=step_details

## load the .ga json
#wf = json.load(open(sys.argv[1]))

else:
    print("Format does not belong to any Galaxy workflow formats")
    sys.exit()

#else:  ## wf format is v0.1
#    cwl_label='Abstract CWL workflow automatically generated from a Galaxy .ga v0.1 workflow file'
#    # iterate over the steps
#    #collect the outputs names
#    # keys=[0,1,2....] and values contain each step information (nested json)
#    for (k, v) in wf_dict['steps'].items():
#        #print("Key: " + k)
#        #print("Value: " + str(v))
#        step_num=k
#        # check if the step is a wf input step
#        if v['type']=="data_input":
#            #print('step '+ str(step_num) + ' contains a workflow input')
#            ## add the output variables of this to the inputs set
#            for output_file in v['workflow_outputs']:
#                input_details={}
#                input_details['type']='File ... need to retrieve more info'
#                input_details['format']='Input files have no info about format'
#                input_id=str(step_num)+'/'+output_file['output_name']
#                #print(input_id)
#                wf_inputs[input_id]=input_details
#        else:
#            step_details={}
#            step_name=v['name']
#            step_id= v['tool_id']+'_'+v['tool_shed_repository']['name']+'_'+v['tool_shed_repository']['changeset_revision']+'_'+v['tool_shed_repository']['owner']+'_'+v['tool_shed_repository']['tool_shed']
#            ## collect the outputs
#            step_outputs={}
#            step_out_list=[]
#            for outp in v['outputs']:
#                output_description={}
#                output_description['type']=outp['type']
#                output_description['doc']='No more info about this output'
#                output_description['doc']=outp
#                step_outputs[outp['name']]=output_description
#            ## get the outputs that will be listed as wf outputs 
#            for step_output in v['workflow_outputs']:
#                output_id=str(step_num)+'/'+step_output['output_name']
#                step_out_details={}
#                step_out_details['type']='File ....should be able to get more info'
#                step_out_details['outputSource']=output_id
#                step_out_list.append(step_output['output_name'])
#                wf_outputs[output_id]=step_out_details
#                #print(step_output['output_name'])
#            #collect the inputs
#            step_inputs={}  ## all inputs, as listed in the inputs: section of run field
#            ## get the inputs from connections
#            step_in_dict={}  # the connecton inputs as listed in the in: section of the step
#            for name,input_connections in v['input_connections'].items():
#                connection_id=str(input_connections['id']) + '/' + input_connections['output_name'] 
#                step_in_dict[name]=connection_id
#                #print("Input " + name + " from step "+ str(step_num)+" comes from " + connection_id) 
#                #also need to save the input in the 
#                input_desc={}
#                input_desc['type']='File -- I have no info about file type'
#                input_desc['doc']='Connected inputs have no description in the .ga file'
#                step_inputs[name]=input_desc
#            for input_entry in v['inputs']:
#                input_desc={}
#                input_desc['type']='File'
#                input_desc['doc']=input_entry['description']
#                step_inputs[input_entry['name']]=input_desc
#            #print(yaml.dump(step_outputs))
#            step_details['in']=step_in_dict
#            step_details['out']=step_out_list
#            ######step_details['out']
#            run_dict={}
#            run_dict['inputs']=step_inputs
#            run_dict['outputs']=step_outputs
#            run_dict['class']='Operation'
#            run_dict['id']=step_id
#            run_dict['doc']="Execute "+ step_name
#            step_details['run']=run_dict
#            steps[str(step_num)]=step_details 


cwl_out['steps']=steps
cwl_out['cwlVersion']='v1.0'
cwl_out['class']='Workflow'
cwl_out['label']=cwl_label
cwl_out['inputs']=wf_inputs
cwl_out['outputs']=wf_outputs
#print(wf_inputs)
#print(wf_outputs)
print(yaml.dump(cwl_out))
