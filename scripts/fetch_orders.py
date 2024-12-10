from dependencies import pd, req, os, time, datetime, load_dotenv
from fetch_payments import fetch_payment_data

load_dotenv()
print("env is loaded")

# Access Square API Token
ACCESS_TOKEN = os.getenv("SQUARE_ACCESS_TOKEN")
if not ACCESS_TOKEN:
    raise ValueError("Square API TOKEN not found in .env file!")

# PAYMENTS_API_URL = 'https://connect.squareup.com/v2/payments'
ORDERS_API_URL = 'https://connect.squareup.com/v2/orders'
headers = {
    "Authorization": f"Bearer {ACCESS_TOKEN}",
    "Content-Type": "application/json"
}

def fetch_order_data(order_ids):
    order_details = []
    order_summaries = []
    missing_orders =[]

    for order_id in order_ids:
        response = req.get(f"{ORDERS_API_URL}/{order_id}", headers=headers)
        print(f"Fetching order ID: {order_id}, Status Code: {response.status_code}")

        
        if response.status_code == 200:
            order = response.json().get("order", {})

            #Extract line items
            if "line_items" in order and order.get("line_items"):
                for item in order["line_items"]:
                    order_details.append({
                        "order_id": order_id,
                        "items_id": item.get("uid"), 
                        "item_name": item.get("name"),
                        "quantity": int(item.get("quantity", "0")),
                        "base_price": item.get("base_price_money", {}).get("amount", 0) / 100,
                        "gross_sales": item.get("gross_sales_money", {}).get("amount", 0) / 100,
                        "total_money": item.get("total_money", {}).get("amount", 0) / 100, 
                        "discount_applied": item.get("total_discount_money", {}).get("amount", 0) / 100,
                    })
            
            # Extract order-level summary
            order_summaries.append({
                "order_id": order_id, 
                "created_at": order.get("created_at"),
                "updated_at": order.get("updated_at"),
                "state": order.get("state"),
                "total_money": order.get("total_money", {}).get("amount", 0) / 100,
                "total_tax_money": order.get("total_tax_money", {}).get("amount", 0) / 100,
                "total_discount_money": order.get("total_discount_money", {}).get("amount", 0) / 100,
                "total_tip_money": order.get("total_tip_money", {}).get("amount", 0) / 100,
                "total_service_charge_money": order.get("total_service_charge_money", {}).get("amount", 0) /100

            })
        elif response.status_code == 404:
            missing_orders.append(order_id)
            print(f"Order not found for ID {order_id}. Skipping")
        else:
            print(f"Error fetching order {order_id}: {response.status_code} - {response.text}")
        time.sleep(0.1) # avoid rate limit
    #log missing orders
    if missing_orders:
        missing_orders_path = "./data/missing_orders.txt"
        with open(missing_orders_path, "w") as file:
            file.write("\n".join(missing_orders))
        print(f"Missing orders IDs logged to: {missing_orders_path}")
    return pd.DataFrame(order_details), pd.DataFrame(order_summaries)

# Test usage ----- TO DO----- may remove
if __name__ == "__main__":
    start_date = "2024-02-01"
    end_date = "2024-02-01"

    output_dir = "./data"
    os.makedirs(output_dir, exist_ok=True)

    payments_data = fetch_payment_data(start_date, end_date)
    payments_csv_path = os.path.join(output_dir, "payment_data.csv")
    payments_data.to_csv(payments_csv_path, index=False)
    print(f"Payments data saved to: {payments_csv_path}")

    order_ids = payments_data["order_id"].dropna().unique()
    orders_details, order_summaries = fetch_order_data(order_ids)

    orders_details_path = os.path.join(output_dir, "orders_details.csv")
    orders_summaries_path = os.path.join(output_dir, "orders_summaries.csv" )

    orders_details.to_csv(orders_details_path, index=False)
    print(f"Orders data saved to: {orders_details_path}")

    order_summaries.to_csv(orders_summaries_path, index=False)
    print(f"Order summaries saved to: {orders_summaries_path}")
