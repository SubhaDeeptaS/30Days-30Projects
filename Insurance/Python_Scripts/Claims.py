import json
import os

# Load the data from the JSON file
with open("Claims.json", "r") as f:
    claims = json.load(f)

# Create a directory to store individual claim files
output_dir = "individual_claims"
os.makedirs(output_dir, exist_ok=True)

# Write each claim to a separate JSON file
for claim in claims:
    claim_id = claim.get("claim_id", "unknown")
    filename = os.path.join(output_dir, f"{claim_id}.json")
    final = {"ClaimData" : claim, "Event" : "Claim"}
    with open(filename, "w") as outfile:
        json.dump(final, outfile, indent=2)

print(f"Saved {len(claims)} individual claim JSON files in '{output_dir}' folder.")
