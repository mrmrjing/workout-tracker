import json

# Define the path to your JSON file
file_path = 'workout.json'

# Load the JSON data from the file
with open(file_path, 'r') as file:
    data = json.load(file)

# Function to recursively convert weight fields to double
def convert_weight_to_double(item):
    if isinstance(item, dict):  # Check if the item is a dictionary
        for key, value in item.items():
            if key == 'weight':
                # Convert the weight to float if it's not already
                item[key] = float(value)
            else:
                # Recursively process all dictionary items
                convert_weight_to_double(value)
    elif isinstance(item, list):  # Check if the item is a list
        for element in item:
            # Recursively process each element in the list
            convert_weight_to_double(element)

# Apply the conversion function to the JSON data
convert_weight_to_double(data)

# Save the updated data back to the file
with open(file_path, 'w') as file:
    json.dump(data, file, indent=4)

print("All 'weight' fields have been converted to double.")
