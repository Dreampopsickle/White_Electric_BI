from dependencies import pd, req, os, time, datetime, load_dotenv
from fetch_payments import fetch_payment_data

load_dotenv()
print("env is loaded")

# Access Square API Token
ACCESS_TOKEN = os.getenv("SQUARE_ACCESS_TOKEN")
if not ACCESS_TOKEN:
    raise ValueError("Square API TOKEN not found in .env file!")

# PAYMENTS_API_URL = 'https://connect.squareup.com/v2/payments'
ORDERS_API_URL = 'https://connect.squareup.com/v2/orders/batch-retrieve'
headers = {
    # "Sqaure-Version": "2024-11-20",
    "Authorization": f"Bearer {ACCESS_TOKEN}",
    "Content-Type": "application/json"
}

print ("Fetching...")
def fetch_order_data(order_ids):
    order_details = []
    line_item_details = []
    missing_orders =[]
    batch_size = 100

    order_ids = list(order_ids)

    for i in range(0, len(order_ids), batch_size):
        batch = order_ids[i:i + batch_size]
        print(f"Fetching batch {i // batch_size + 1} with {len(batch)} orders.")

        response = req.post(ORDERS_API_URL, headers=headers, json={"order_ids": batch})
        print(f"Status Code: {response.status_code}")

        if response.status_code == 200:
            orders = response.json().get("orders", [])

            for order in orders: 
                order_details.append({
                   "order_id": order["id"],
                    "location_id": order.get("location_id"),
                    "created_at": order.get("created_at"),
                    "updated_at": order.get("updated_at"),
                    "state": order.get("state"),
                    "total_money": order.get("total_money", {}).get("amount", 0) / 100,
                    "total_tax_money": order.get("total_tax_money", {}).get("amount", 0) / 100,
                    "total_tip_money": order.get("total_tip_money", {}).get("amount", 0) / 100,
                    "total_discount_money": order.get("total_discount_money", {}).get("amount", 0) / 100,
                    "total_service_charge_money": order.get("total_service_charge_money", {}).get("amount", 0) / 100, 
                })

                for item in order.get("line_items", []):
                    line_item_details.append({
                        "order_id": order["id"],
                        "line_item_uid": item.get("uid"),
                        "item_name": item.get("name"),
                        "catalog_id": item.get("catalog_object_id"),
                        "catalog_version": int(item.get("catalog_version", "0")),
                        "quantity": int(item.get("quantity", "0")),
                        "base_price": item.get("base_price_money", {}).get("amount", 0) / 100,
                        "gross_sales": item.get("gross_sales_money", {}).get("amount", 0) / 100,
                        "total_money": item.get("total_money", {}).get("amount", 0) / 100,
                    })

                    for modifier in item.get("modifiers", []):
                        line_item_details.append({
                            "order_id": order["id"],
                            "line_item_uid": item.get("uid"),
                            "modifier_name": modifier.get("name"),
                            "modifier_price": modifier.get("total_price_money", {}).get("amount", 0) / 100,
                        })

        elif response.status_code == 404:
            print(f"Batch failed: {batch}")
            missing_orders.extend(batch)
        else: 
            print(f"Error: {response.status_code} - {response.text}")
        time.sleep(0.1) #Prevent rate limit

    if missing_orders:
        missing_orders_path = "./data/missing_orders.txt"
        with open(missing_orders_path, "w") as file:
            file.write("\n".join(missing_orders))
        print(f"Missing order IDs logged to: {missing_orders_path}")

    return pd.DataFrame(order_details), pd.DataFrame(line_item_details)

# Test usage ----- TO DO----- may remove
if __name__ == "__main__":
    start_date = "2021-05-01"
    end_date = "2024-12-31"
    output_dir = "./data"
    os.makedirs(output_dir, exist_ok=True)

    payments_data = fetch_payment_data(start_date, end_date)
    payments_csv_path = os.path.join(output_dir, "payment_data.csv")
    payments_data.to_csv(payments_csv_path, index=False)
    print(f"Payments data saved to: {payments_csv_path}")

    order_ids = payments_data["order_id"].dropna().unique()
    orders_df, line_items_df = fetch_order_data(order_ids)

    orders_path = os.path.join(output_dir, "orders_data.csv")
    line_items_path = os.path.join(output_dir, "line_items_data.csv" )

    orders_df.to_csv(orders_path, index=False)
    print(f"Orders data saved to: {orders_path}")

    line_items_df.to_csv(line_items_path, index=False)
    print(f"Line items data saved to: {line_items_path}")

    print("Fetch complete.")
