import json
import os

# Load the data from the JSON file
with open("Policies.json", "r") as f:
    Policies = json.load(f)

# Create a directory to store individual policy files
output_dir = "individual_Policies"
os.makedirs(output_dir, exist_ok=True)

# Write each policy to a separate JSON file
for policy in Policies:
    policy_id = policy.get("policy_id", "unknown")
    filename = os.path.join(output_dir, f"{policy_id}.json")
    final = {"PolicyData" : policy, "Event" : "Policy"}
    with open(filename, "w") as outfile:
        json.dump(final, outfile, indent=2)

print(f"Saved {len(Policies)} individual policy JSON files in '{output_dir}' folder.")
