import sys
import json

## Just prints the yaml content stored in the yaml_content key




json_wf=json.load(open(sys.argv[1]))
print(json_wf['yaml_content'])
