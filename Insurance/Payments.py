import json
import os

# Load the data from the JSON file
with open("Payments.json", "r") as f:
    payments = json.load(f)
f.close()
# Create a directory to store individual payment files
output_dir = "individual_payments"
os.makedirs(output_dir, exist_ok=True)

# Write each payment to a separate JSON file
for payment in payments:
    payment_id = payment.get("payment_id", "unknown")
    filename = os.path.join(output_dir, f"{payment_id}.json")
    final = {"PaymentData" : payment, "Event" : "Payment"}
    with open(filename, "w") as outfile:
        json.dump(final, outfile, indent=2)

print(f"Saved {len(payments)} individual payment JSON files in '{output_dir}' folder.")
