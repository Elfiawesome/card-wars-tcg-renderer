from pathlib import Path
import json
for file in Path("C:\\Users\\elfia\\OneDrive\\Desktop\\card-wars-tcg-renderer\\data\\cards\\units\\").rglob("*"):
	new_data = {}
	if file.is_file():
		with file.open('r', encoding='utf-8') as f:
			data = json.load(f)
			print(file)
		
	
	# with file.open('w', encoding='utf-8') as f:
	# 	json.dump(new_data, f)