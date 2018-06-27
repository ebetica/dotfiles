import json
import colour
import sys
import random

# SemanticHighlight uses 256 colors. Plug the background of your terminal to
# discover what colors to pass to semantic highlight for good visibility
#   python getcolors.py "#002B36"

c = colour.Color(sys.argv[1])
with open("data.json", "r") as f:
    data = json.load(f)
asdf = []
for field in data:
    if abs(field['hsl']['l'] - c.hsl[2]*100) > 50:
        asdf.append(field['colorId'])
random.shuffle(asdf)
print(asdf)
