import json
import os

# Load the data from the JSON file
with open("Addresses.json", "r") as f:
    addresses = json.load(f)

# Create a directory to store individual address files
output_dir = "individual_addresses"
os.makedirs(output_dir, exist_ok=True)

# Write each address to a separate JSON file
for address in addresses:
    address_id = address.get("address_id", "unknown")
    filename = os.path.join(output_dir, f"{address_id}.json")
    final = {"AddressData" : address, "Event" : "Address"}
    with open(filename, "w") as outfile:
        json.dump(final, outfile, indent=2)

print(f"Saved {len(addresses)} individual address JSON files in '{output_dir}' folder.")
