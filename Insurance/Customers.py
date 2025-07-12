import json
import os

# Load the data from the JSON file
with open("Customers.json", "r") as f:
    customers = json.load(f)

# Create a directory to store individual payment files
output_dir = "individual_customers"
os.makedirs(output_dir, exist_ok=True)

# Write each payment to a separate JSON file
for customer in customers:
    customer_id = customer.get("customer_id", "unknown")
    filename = os.path.join(output_dir, f"{customer_id}.json")
    final = {"CustomerData" : customer, "Event" : "Customer"}
    with open(filename, "w") as outfile:
        json.dump(final, outfile, indent=2)

print(f"Saved {len(customers)} individual payment JSON files in '{output_dir}' folder.")
