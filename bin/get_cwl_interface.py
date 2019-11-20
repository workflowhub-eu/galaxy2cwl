#!/bin/env python

import json 
import sys 
import pyyaml

## load the .ga json
wf = json.load(open(sys.argv[1]))

# iterate over the steps
#collect the outputs names
wf_inputs=[]
wf_outputs=[]
steps={}

# keys=[0,1,2....] and values contain each step information (nested json)
for (k, v) in wf['steps'].items():
    #print("Key: " + k)
    #print("Value: " + str(v))
    step_num=k
     
    # check if the step is a wf input step
    if v['type']=="data_input":
        print('step '+ str(step_num) + ' contains a workflow input')
        ## add the output variables of this to the inputs set
        for output_file in v['workflow_outputs']:
            input_id=str(step_num)+'_'+output_file['output_name']
            print(input_id)
            wf_inputs.append(input_id)
    else:
        ## collect the outputs
        step_outputs={}
        for outp in v['outputs']:
            output_description={}
            output_description['type']=outp['type']
            output_description['doc']='No more info about this output'
            output_description['doc']=outp
            step_outputs[outp['name']]=output_description
        ## get the outputs that will be listed as wf outputs 
        for step_output in v['workflow_outputs']:
            output_id=str(step_num)+'/'+step_output['output_name']
            wf_outputs.append(output_id)
            #print(step_output['output_name'])
        #collect the inputs
        step_inputs={}
        ## get the inputs from connections
        step_in_dict={}
        for name,input_connections in v['input_connections'].items():
            connection_id=str(input_connections['id']) + '/' + input_connections['output_name'] 
            step_in_dict[name]=connection_id
            print("Input " + name + " from step "+ str(step_num)+" comes from " + connection_id) 
            #also need to save the input in the 
            input_desc={}
            input_desc['type']='File -- I have no info about file type'
            input_desc['doc']='Connected inputs have no description in the .ga file'
            step_inputs[name]=input_desc
        for input_entry in v['inputs']:
            input_desc={}
            input_desc['type']='File'
            input_desc['doc']=input_entry['description']
            step_inputs[input_entry['name']]=input_desc
print(wf_inputs)
print(wf_outputs)

